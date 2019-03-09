require 'spec_helper'

RSpec.describe CloudCompose::Parser do
  subject { CloudCompose::Parser.load_yaml(content) }

  let(:dumped) { CloudCompose::Parser.dump_yaml(subject) }

  describe '!Base64' do
    context 'given a scalar' do
      let(:content) { "---\nget: !Base64 Value to be encoded" }

      it { expect(dumped).to eq "---\nget: !Base64 Value to be encoded\n" }
    end

    context 'given a multi-line value' do
      let(:content) do
        <<~EOF
          get: !Base64 |
            This is a multi-line encoded.

            This is another Line.
          foo: !Ref BarBaz
        EOF
      end

      it { expect(dumped).to eq "---\nget: !Base64 'This is a multi-line encoded.\n\n\n  This is another Line.\n\n'\nfoo: !Ref BarBaz\n" }
    end

    context 'given a full name' do
      let(:content) { "---\nget: Fn::Base64 !Ref \"Value to be encoded\"" }

      it { expect(dumped).to eq "---\nget: Fn::Base64 !Ref \"Value to be encoded\"\n" }
    end
  end

  describe '!Ref' do
    context 'given a scalar' do
      let(:content) { "---\nget: !Ref testing-string" }

      it { expect(dumped).to eq "---\nget: !Ref testing-string\n" }
    end

    context 'given a sequence' do
      let(:content) { "---\nget: !Ref [ testing-string ]" }

      it 'raises an error' do
        expect { subject }.to raise_error(CloudCompose::Tags::InvalidTypeError) do |error|
          expect(error.message).to eq 'Invalid Type (seq) for tag `!Ref`'
        end
      end
    end
  end

  describe '!GetAtt' do
    context 'given a sequence' do
      let(:content) { "---\nget: !GetAtt [ One, Two ]" }

      it { expect(dumped).to eq "---\nget: !GetAtt\n- One\n- Two\n" }
    end

    context 'given a string' do
      let(:content) { "---\nget: !GetAtt One.Two.Three" }

      it { expect(dumped).to eq "---\nget: !GetAtt\n- One\n- Two.Three\n" }
    end

    context 'given a map' do
      let(:content) { "---\nget: !GetAtt\n  one: One\n  two: Two\n" }

      it 'raises an error' do
        expect { subject }.to raise_error(CloudCompose::Tags::InvalidTypeError) do |error|
          expect(error.message).to eq 'Invalid Type (map) for tag `!GetAtt`'
        end
      end
    end
  end

  describe '!Sub' do
    context 'given a sequence' do
      let(:content) do
        <<~EOF
          ---
          value: !Sub
            - 'cf:${AWS::Region}:vpc:${VPCID}'
            - VPCID: !Ref VPCResource
        EOF
      end

      it { expect(dumped).to eq "---\nvalue: !Sub\n- cf:${AWS::Region}:vpc:${VPCID}\n- VPCID: !Ref VPCResource\n" }
    end

    context 'given single value sequence' do
      let(:content) do
        <<~EOF
          ---
          value: !Sub
            - 'cf:${AWS::Region}:vpc'
        EOF
      end

      it { expect(dumped).to eq "---\nvalue: !Sub\n- cf:${AWS::Region}:vpc\n- {}\n" }
    end

    context 'given single value scalar' do
      let(:content) do
        <<~EOF
          ---
          value: !Sub cf:${AWS::Region}:vpc
        EOF
      end

      it { expect(dumped).to eq "---\nvalue: !Sub\n- cf:${AWS::Region}:vpc\n- {}\n" }
    end

    context 'given a map' do
      let(:content) { "---\nget: !Sub\n  one: One\n  two: Two\n" }

      it 'raises an error' do
        expect { subject }.to raise_error(CloudCompose::Tags::InvalidTypeError) do |error|
          expect(error.message).to eq 'Invalid Type (map) for tag `!Sub`'
        end
      end
    end
  end

  describe '!Cidr' do
    context 'given a sequence' do
      let(:content) do
        <<~EOF
          ---
          value: !Cidr [ "192.168.0.0/24", 6, 5 ]
        EOF
      end

      it { expect(dumped).to eq "---\nvalue: !Cidr\n- 192.168.0.0/24\n- 6\n- 5\n" }
    end

    context 'given a scalar' do
      let(:content) { "---\nget: !Cidr testing-value" }

      it 'raises an error' do
        expect { subject }.to raise_error(CloudCompose::Tags::InvalidTypeError) do |error|
          expect(error.message).to eq 'Invalid Type (scalar) for tag `!Cidr`'
        end
      end
    end
  end

  describe '!FindInMap' do
    context 'given a sequence' do
      let(:content) do
        <<~EOF
          ---
          value: !FindInMap [ One, Two, Three ]
        EOF
      end

      it { expect(dumped).to eq "---\nvalue: !FindInMap\n- One\n- Two\n- Three\n" }
    end
  end

  describe '!GetAZs' do
    let(:content) do
      <<~EOF
        ---
        value: !GetAZs us-east-1
      EOF
    end

    it { expect(dumped).to eq "---\nvalue: !GetAZs us-east-1\n" }
  end

  describe '!ImportValue' do
    let(:content) do
      <<~EOF
        ---
        value: !ImportValue NetworkStackSubnetID
      EOF
    end

    it { expect(dumped).to eq "---\nvalue: !ImportValue NetworkStackSubnetID\n" }
  end

  describe '!Join' do
    let(:content) do
      <<~EOF
        ---
        value: !Join
          - '.'
          - - One
            - Two
      EOF
    end

    it { expect(dumped).to eq "---\nvalue: !Join\n- \".\"\n- - One\n  - Two\n" }
  end

  describe '!Select' do
    let(:content) do
      <<~EOF
        ---
        value: !Select
          - 1
          - - One
            - Two
      EOF
    end

    it { expect(dumped).to eq "---\nvalue: !Select\n- 1\n- - One\n  - Two\n" }
  end

  describe '!Split' do
    let(:content) do
      <<~EOF
        ---
        value: !Split
          - .
          - One.Two
      EOF
    end

    it { expect(dumped).to eq "---\nvalue: !Split\n- \".\"\n- One.Two\n" }
  end

  describe '!Transform' do
    context 'given a valid map' do
      let(:content) do
        <<~EOF
          ---
          value: !Transform
            Name: AWS::Include
            Parameters:
              Location: FooBar
        EOF
      end

      it { expect(dumped).to eq content }
    end

    context 'given a scalar' do
      let(:content) { "---\nget: !Transform testing-value" }

      it 'raises an error' do
        expect { subject }.to raise_error(CloudCompose::Tags::InvalidTypeError) do |error|
          expect(error.message).to eq 'Invalid Type (scalar) for tag `!Transform`'
        end
      end
    end
  end

  describe '!And' do
    let(:content) do
      <<~EOF
        ---
        value: !And
        - !Equals
          - sg-mysggroup
          - !Ref ASecurityGroup
        - !Condition SomeOtherCondition
      EOF
    end

    it { expect(dumped).to eq content }
  end
end
