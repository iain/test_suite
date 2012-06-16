require 'test_suite/configuration'

describe TestSuite::Configuration do

  it "may have no commands" do
    subject.commands.should be_empty
  end

  it "can create and remember commands" do
    subject.command :ls
    subject.command :dir
    subject.commands.first.name.should eq :ls
    subject.commands.last.name.should eq :dir
  end

  it "can configure commands via a block" do
    command = :nothing
    subject.command :ls do |cmd|
      command = cmd
    end
    command.name.should eq :ls
  end

end
