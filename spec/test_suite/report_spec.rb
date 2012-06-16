# encoding: utf-8
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
    stderr.should eq <<-DOC
┌─────────┬─────────┬─────────┐
│ Command │ Runtime │ Status  │
├─────────┼─────────┼─────────┤
│ ls      │  0.400s │ success │
│ foobar  │  1.400s │ failed  │
└─────────┴─────────┴─────────┘
    DOC
  end

end
