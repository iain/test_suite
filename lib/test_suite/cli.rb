require 'thor'
require 'test_suite/runner'

module TestSuite
  class CLI < Thor

    # TODO load the configuration

    desc "go", "Runs your test suite"
    def go
      runner = Runner.call(TestSuite.configuration.commands)
      exit runner.exit_status
    end

    desc "generate", "Generates a dummy config file"
    def generate
    end

  end
end
