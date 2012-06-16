require 'test_suite'

describe TestSuite do

  it "can be configured" do
    expect { |b| subject.configure(&b) }.to yield_with_args(subject.configuration)
  end

end
