require 'psych'

require_relative 'tags/simple_type'

require_relative 'tags/get_att'
require_relative 'tags/sub'
require_relative 'tags/random'

module CloudCompose
  class Parser
    CUSTOM_TAGS = {
      '!And' => CloudCompose::Tags::And,
      '!Base64' => CloudCompose::Tags::Base64,
      '!Cidr' => CloudCompose::Tags::Cidr,
      '!Condition' => CloudCompose::Tags::Condition,
      '!Equals' => CloudCompose::Tags::Equals,
      '!FindInMap' => CloudCompose::Tags::FindInMap,
      '!GetAZs' => CloudCompose::Tags::GetAzs,
      '!GetAtt' => CloudCompose::Tags::GetAtt,
      '!If' => CloudCompose::Tags::If,
      '!ImportValue' => CloudCompose::Tags::ImportValue,
      '!Join' => CloudCompose::Tags::Join,
      '!Not' => CloudCompose::Tags::Not,
      '!Or' => CloudCompose::Tags::Or,
      '!Random' => CloudCompose::Tags::Random,
      '!Ref' => CloudCompose::Tags::Ref,
      '!Select' => CloudCompose::Tags::Select,
      '!Split' => CloudCompose::Tags::Split,
      '!Sub' => CloudCompose::Tags::Sub,
      '!Transform' => CloudCompose::Tags::Transform
    }.freeze

    class << self
      def load_yaml(content)
        Psych.safe_load(content, CUSTOM_TAGS.values)
      end

      def dump_yaml(object)
        Psych.dump(object)
      end
    end
  end
end

CloudCompose::Parser::CUSTOM_TAGS.each do |key, klass|
  Psych.add_tag(key, klass)
end
