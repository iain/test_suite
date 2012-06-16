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

    it "raises an exception if already ignored" do
      command.never_fails_build!
      expect { command.fails_build_immediately! }.to raise_error TestSuite::AmbiguousImportance
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

    it "raises an exception if already important" do
      command.fails_build_immediately!
      expect { command.never_fails_build! }.to raise_error TestSuite::AmbiguousImportance
    end

  end

  describe "#run!" do

    it "runs an command" do
      stdout, stderr = *run("echo this is a test")
      stdout.should eq "this is a test\r\n"
    end

    it "can do something successfully" do
      run successful_command
      command.should be_ok
    end

    it "can fail at doing something" do
      run failing_command
      command.should_not be_ok
    end

    it "can fail because the command cannot be found" do
      stdout, stderr = *run("blahblahblah")
      command.should_not be_ok
      stderr.should eq "No such file or directory - blahblahblah\n"
    end

    it "raises CommandFailed if the the build should fail immediately" do
      command.fails_build_immediately!
      expect { run failing_command }.to raise_error TestSuite::CommandFailed
    end

    it "is still ok if command can be ignored" do
      command.never_fails_build!
      run failing_command
      command.should be_ok
    end

  end

  describe "#runtime" do

    it "measures runtime" do
      run "sleep 0.2"
      command.runtime.should be_within(0.1).of(0.2)
    end

  end

  describe "#status" do

    it "is 'success' when it worked" do
      run successful_command
      command.status.should eq "success"
    end

    it "is 'failed' when it failed" do
      run failing_command
      command.status.should eq "failed"
    end

    it "is 'broke the build' when it broke the build immediately" do
      command.fails_build_immediately!
      run failing_command rescue :whatever
      command.status.should eq "broke the build"
    end

    it "is 'failed, but ignored' when it was ignored" do
      command.never_fails_build!
      run failing_command
      command.status.should eq "failed, but ignored"
    end

    it "is \"didn't run\" when the command didn't run" do
      command.status.should eq "didn't run"
    end

  end

  let(:successful_command) { "test 1" }
  let(:failing_command) { "test" }

  def run(what)
    command.runs what
    capture { command.run! }
  end

end
