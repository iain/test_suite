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
    stdout, stderr = *capture do
      command.run!
    end
    stdout.should == "this is a test\r\n"
  end

end
