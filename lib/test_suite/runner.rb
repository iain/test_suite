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
      last_run = 0
      commands.each_with_index do |command, index|
        last_run = index + 1
        command.run!
      end
    rescue CommandFailed => error
      commands[last_run..-1].select(&:always_run?).each(&:run!)
    ensure
      Report.call(commands)
    end

    def exit_status
      commands.all?(&:ok?) ? 0 : 1
    end

  end
end
