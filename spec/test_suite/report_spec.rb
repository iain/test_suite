# encoding: utf-8
require 'test_suite/report'

describe TestSuite::Report do

  let(:stdout) { StringIO.new }
  let(:stderr) { StringIO.new }

  around do |example|
    $stdout = stdout
    $stderr = stderr
    example.call
    $stdout = STDOUT
    $stderr = STDERR
  end

  it "prints out a report" do
    ls = stub :ls, :name => :ls, :runtime => 0.4, :status => "success"
    foobar = stub :foobar, :name => :foobar, :runtime => 1.4, :status => "failed"
    configuration = stub :commands => [ ls, foobar ]
    TestSuite::Report.call(configuration)
    stderr.rewind
    stderr.read.should eq <<-DOC
┌─────────┬─────────┬─────────┐
│ Command │ Runtime │ Status  │
├─────────┼─────────┼─────────┤
│ ls      │  0.400s │ success │
│ foobar  │  1.400s │ failed  │
└─────────┴─────────┴─────────┘
    DOC
  end

end
