TestSuite.configure do |config|
  config.command :bundle
  config.command :rspec do |cmd|
    cmd.runs "bundle exec rspec -fp"
  end
  config.command :ls
end
