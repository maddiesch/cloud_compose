require 'spec_helper'

RSpec.describe CloudCompose::Template do
  let(:path) { template_path('example_vpc', 'template.yml') }

  describe '#to_s' do
    let(:template) { described_class.new(path, '') }

    it 'does not raise an error' do
      expect { template.to_s }.to_not raise_error
    end
  end

  describe 'given local imports' do
    let(:template) { described_class.new(template_path('readme.yml'), '') }

    it 'does not raise an error' do
      expect { template.to_s }.to_not raise_error
    end
  end
end
