require 'test_suite/cli'

describe TestSuite::CLI do

  it "runs the tests" do
    TestSuite::Runner.should_receive(:call)
    subject.go
  end

end
