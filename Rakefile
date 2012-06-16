#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'test_suite/rake_task'
TestSuite::RakeTask.new(:test, "script/suite.rb")

task :default => :test
