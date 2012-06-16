require 'thor'

module TestSuite
  class CLI < Thor

    desc "go", "Runs your test suite"
    def go
      puts "Running your test suites"
    end

    desc "generate", "Generates a dummy config file"
    def generate
      puts "Generating your test suites"
    end

  end
end
