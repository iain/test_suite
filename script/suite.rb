TestSuite.configure do |config|

  config.command :rspec do |cmd|
    cmd.runs "bundle exec rspec -f Fuubar"
  end

end
