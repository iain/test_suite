require 'test_suite'

describe "A place to start" do

  it "can configure commands" do
    TestSuite.configure do |config|
      config.command :ls
      config.command :foo
    end

    TestSuite.should have(2).commands
  end

end
