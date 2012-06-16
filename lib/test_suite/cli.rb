require 'thor'
require 'test_suite/runner'

module TestSuite
  class CLI < Thor

    desc "go", "Runs your test suite"
    def go
      Runner.call
    end

    desc "generate", "Generates a dummy config file"
    def generate
    end

  end
end
