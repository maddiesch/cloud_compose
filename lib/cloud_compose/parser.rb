require 'psych'

require_relative 'tags/simple_type'

require_relative 'tags/get_att'
require_relative 'tags/sub'

module CloudCompose
  class Parser
    CUSTOM_TAGS = {
      '!Base64' => CloudCompose::Tags::Base64,
      '!Cidr' => CloudCompose::Tags::Cidr,
      '!FindInMap' => CloudCompose::Tags::FindInMap,
      '!GetAtt' => CloudCompose::Tags::GetAtt,
      '!Ref' => CloudCompose::Tags::Ref,
      '!Sub' => CloudCompose::Tags::Sub
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
