require "test_suite/version"
require "test_suite/configuration"
require "test_suite/runner"

module TestSuite

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.run!
    exit run.exit_status
  end

  def self.run
    Runner.call(configuration.commands)
  end

end
