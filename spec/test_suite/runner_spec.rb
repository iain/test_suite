require 'test_suite/runner'

describe TestSuite::Runner do

  before do
    TestSuite::Report.stub(:call)
  end

  it "runs a certain configuration" do
    command = stub :command
    configuration = stub :configuration, :commands => [ command ]
    command.should_receive(:run!)
    TestSuite::Runner.call(configuration)
  end

  it "may be halted immediately, due to a failed command" do
    failing_command = stub :failing_command
    next_command = stub :next_command
    configuration = stub :configuration, :commands => [ failing_command, next_command ]
    failing_command.stub(:run!) { raise TestSuite::CommandFailed, "some reason" }
    next_command.should_not_receive(:run!)
    TestSuite::Runner.call(configuration)
  end

  it "has exit status 0 when everycommand went ok" do
    command = stub :command, :run! => true
    configuration = stub :configuration, :commands => [ command ]
    command.should_receive(:ok?).and_return(true)
    runner = TestSuite::Runner.call(configuration)
    runner.exit_status.should be 0
  end

  it "has exit status 1 when a command failed" do
    command = stub :command, :run! => true
    configuration = stub :configuration, :commands => [ command ]
    command.should_receive(:ok?).and_return(false)
    runner = TestSuite::Runner.call(configuration)
    runner.exit_status.should be 1
  end

  it "reports the status of the commands" do
    command = stub :command, :run! => true
    configuration = stub :configuration, :commands => [ command ]
    TestSuite::Report.should_receive(:call).with(configuration)
    TestSuite::Runner.call(configuration)
  end

  it "also reports the status when the build was halted" do
    command = stub :command
    configuration = stub :configuration, :commands => [ command ]
    command.stub(:run!) { raise TestSuite::CommandFailed, "some reason" }
    TestSuite::Report.should_receive(:call).with(configuration)
    TestSuite::Runner.call(configuration)
  end


end
