require 'test_suite'
require 'test_suite/cli'

require 'rake'
require 'rake/tasklib'

module TestSuite
  class RakeTask < ::Rake::TaskLib
    include ::Rake::DSL if defined?(::Rake::DSL)

    def initialize(name, filename)
      desc "Run test suite as defined in #{filename}"
      task name do
        TestSuite::CLI.start([filename])
      end
    end

  end
end
