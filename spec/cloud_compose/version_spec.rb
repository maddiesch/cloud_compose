require 'spec_helper'

RSpec.describe CloudCompose do
  it 'has a valid version number' do
    expect(CloudCompose::VERSION).to_not be_nil
  end
end
