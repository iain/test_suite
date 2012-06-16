require 'test_suite/command'

module TestSuite
  class Configuration

    def commands
      @commands ||= []
    end

    def command(name)
      command = Command.new(name)
      yield command if block_given?
      commands << command
    end

  end
end
