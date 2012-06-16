TestSuite.configure do |config|

  config.command "bundle update"

  config.command :rspec do |cmd|
    cmd.runs "bundle exec rspec -fp"
  end

end
