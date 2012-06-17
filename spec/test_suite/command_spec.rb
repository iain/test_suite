require 'test_suite/command'
require 'support/io_helper'

describe TestSuite::Command do

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

  describe "#always_run!" do

    it "is off by default" do
      command.should_not be_always_run
    end

    it "can be turned on" do
      command.always_run!
      command.should be_always_run
    end

  end


  describe "#run!" do

    it "runs an command" do
      executor.should_receive(:run).with("echo this is a test")
      run("echo this is a test")
    end

    it "can do something successfully" do
      run successful_command
      command.should be_ok
    end

    it "can fail at doing something" do
      run failing_command
      command.should_not be_ok
    end

    it "raises CommandFailed if the the build should fail immediately" do
      command.fails_build_immediately!
      expect { run failing_command }.to raise_error TestSuite::CommandFailed
    end

    it "doesn't raise CommandFailed if the build was successful" do
      command.fails_build_immediately!
      run successful_command
      command.should be_ok
    end

    it "is still ok if command can be ignored" do
      command.never_fails_build!
      run failing_command
      command.should be_ok
    end

  end

  describe "#runtime" do

    it "measures runtime" do
      executor.stub(:run) { sleep 0.1 }
      run
      command.runtime.should be_within(0.1).of(0.1)
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
  let(:executor) { stub :executor, :run => 0 }

  def failing_command
    cmd = "failing command"
    executor.stub(:run).with(cmd).and_return(1)
    cmd
  end

  def successful_command
    cmd = "successful command"
    executor.stub(:run).with(cmd).and_return(0)
    cmd
  end

  def run(what = "unspecified command")
    command.runs what
    command.run! executor
  end

end
