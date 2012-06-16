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

  describe "#fails_build_immediately!" do

    it "is not important to fail the build immediately" do
      command.should_not be_important
    end

    it "can fail the build immediately" do
      command.fails_build_immediately!
      command.should be_important
    end

  end

  describe "#never_fails_build!" do

    it "should not be ignored by default" do
      command.should_not be_ignored
    end

    it "can be ignored" do
      command.never_fails_build!
      command.should be_ignored
    end

  end

  describe "#run!" do

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

    it "is still ok if command can be ignored" do
      command.never_fails_build!
      command.runs "ls missing/directory"
      capture { command.run! }
      command.should be_ok
    end

  end

  describe "#runtime" do

    it "measures runtime" do
      command.runs "sleep 0.1"
      capture { command.run! }
      command.runtime.should be_within(0.01).of(0.1)
    end

  end

  describe "#status" do

    it "is 'success' when it worked" do
      command.runs "ls"
      capture { command.run! }
      command.status.should eq "success"
    end

    it "is 'failed' when it failed" do
      command.runs "ls missing/directory"
      capture { command.run! }
      command.status.should eq "failed"
    end

    it "is 'broke the build' when it broke the build immediately" do
      command.fails_build_immediately!
      command.runs "ls missing/directory"
      expect { capture { command.run! } }.to raise_error(TestSuite::CommandFailed)
      command.status.should eq "broke the build"
    end

    it "is 'failed, but ignored' when it was ignored" do
      command.never_fails_build!
      command.runs "ls missing/directory"
      capture { command.run! }
      command.status.should eq "failed, but ignored"
    end

    it "is \"didn't run\" when the command didn't run" do
      command.status.should eq "didn't run"
    end

  end

end
