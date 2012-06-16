require "test_suite/command_failed"
require "test_suite/report"

module TestSuite
  class Runner

    def self.call(configuration)
      runner = new(configuration)
      runner.call
      runner
    end

    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
    end

    def call
      configuration.commands.each(&:run!)
    rescue CommandFailed => error
    ensure
      Report.call(configuration)
    end

    def exit_status
      configuration.commands.all?(&:ok?) ? 0 : 1
    end

  end
end
