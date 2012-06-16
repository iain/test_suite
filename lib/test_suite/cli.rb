require 'test_suite'
require 'test_suite/runner'

module TestSuite
  class CLI

    def self.start(args)
      args.each do |file|
        load File.expand_path(file)
      end
      TestSuite.run!
    end

  end
end
