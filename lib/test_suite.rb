require "test_suite/version"
require "test_suite/configuration"

module TestSuite

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.commands
    configuration.commands
  end

end
