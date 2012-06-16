require 'test_suite/command'
require 'support/io_helper'

describe TestSuite::Command do
  include IOHelper

  let(:name) { :name }
  let(:command) { TestSuite::Command.new(name) }

  it "requires a name" do
    command.name.should be name
  end

  it "can receive a command" do
    cmd = "ls -alh"
    command.runs cmd
    command.run.should be cmd
  end

  it "uses the name as a command" do
    command.run.should eq "name"
  end

  it "is not important to fail the build immediately" do
    command.should_not be_important
  end

  it "can fail the build immediately" do
    command.fails_build_immediately!
    command.should be_important
  end

  it "should not be ignored by default" do
    command.should_not be_ignored
  end

  it "can be ignored" do
    command.never_fails_build!
    command.should be_ignored
  end

  it "runs an command" do
    command.runs "echo this is a test"
    stdout, stderr = *capture { command.run! }
    stdout.should eq "this is a test\r\n"
  end

  it "can do something successfully" do
    command.runs "ls"
    capture { command.run! }
    command.should be_ok
  end

  it "can fail at doing something" do
    command.runs "ls missing/directory"
    capture { command.run! }
    command.should_not be_ok
  end

  it "can fail because the command cannot be found" do
    command.runs "blahblahblah" # assuming you don't have this command
    stdout, stderr = *capture { command.run! }
    command.should_not be_ok
    stderr.should eq "No such file or directory - blahblahblah\n"
  end

  it "raises CommandFailed if the the build should fail immediately" do
    command.fails_build_immediately!
    command.runs "ls missing/directory"
    expect {
      capture { command.run! }
    }.to raise_error TestSuite::CommandFailed
  end

  it "measures runtime" do
    command.runs "sleep 0.1"
    capture { command.run! }
    command.runtime.should be_within(0.01).of(0.1)
  end

end
