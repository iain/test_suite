require 'test_suite/report'
require 'support/io_helper'

describe TestSuite::Report do
  include IOHelper

  it "prints out a report" do
    ls     = stub :ls,      :name => :ls,      :runtime => 0.4,  :status => "success"
    foobar = stub :foobar,  :name => :foobar,  :runtime => 1.4,  :status => "failed"
    stdout, stderr = *capture do
      TestSuite::Report.call([ls, foobar])
    end
    expected_report = File.open('spec/report.txt', 'r').read
    if stderr.respond_to?(:force_encoding)
      stderr.force_encoding('utf-8').should eq expected_report
    else
      stderr.should eq expected_report
    end
  end

end
