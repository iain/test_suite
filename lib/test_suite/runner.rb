require "test_suite/command_failed"
require "test_suite/report"

module TestSuite
  class Runner

    def self.call(commands)
      runner = new(commands)
      runner.call
      runner
    end

    attr_reader :commands

    def initialize(commands)
      @commands = commands
    end

    def call
      commands.each(&:run!)
    rescue CommandFailed => error
    ensure
      Report.call(commands)
    end

    def exit_status
      commands.all?(&:ok?) ? 0 : 1
    end

  end
end
