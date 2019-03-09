require 'spec_helper'

RSpec.describe CloudCompose::Processor do
  describe '.preprocess' do
    let(:params) { { 'name' => 'CloudCompose', 'is_testing' => 'true' } }

    context 'given a valid string and context' do
      let(:content) { 'foo_$(name)_baz' }

      it { expect(described_class.preprocess(content, params)).to eq 'foo_CloudCompose_baz' }
    end

    context 'given a more compex string' do
      let(:content) do
        <<~EOF
          ---
          Testing$(name)Parameter:
            IsTesting: $(is_testing)
            Payload: !Base64 |
              {
                "Testing": $(is_testing),
                "Name": "$(name)",
                "Deatils": "A replace string with $(name) $ ( )"
              }
        EOF
      end

      it 'matches the expected output' do
        output = <<~EOF
          ---
          TestingCloudComposeParameter:
            IsTesting: true
            Payload: !Base64 |
              {
                "Testing": true,
                "Name": "CloudCompose",
                "Deatils": "A replace string with CloudCompose $ ( )"
              }
        EOF

        expect(described_class.preprocess(content, params)).to eq output
      end
    end
  end
end
