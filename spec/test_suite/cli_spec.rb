require 'test_suite/cli'

describe TestSuite::CLI do

  let(:status) { stub :status }
  let(:runner) { stub :runner, :exit_status => status }

  before do
    subject.stub(:exit)
    TestSuite::Runner.stub(:call) { runner }
  end

  it "runs the tests" do
    TestSuite::Runner.should_receive(:call).with(TestSuite.configuration)
    subject.go
  end

  it "exits with the exit status of the runner" do
    subject.should_receive(:exit).with(status)
    subject.go
  end

end
