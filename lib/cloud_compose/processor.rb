module CloudCompose
  class Processor
    PRE_PROCESSOR_PARAMETER_REGEXP = Regexp.new('\$\((?:[a-zA-Z0-9_]+)\)?').freeze
    PRE_PROCESSOR_PARAMETER_NAME_REGEXP = Regexp.new('\A\$\((?<token>[a-zA-Z0-9_]+)\)?\z').freeze

    class << self
      def preprocess(content, context)
        content.gsub(PRE_PROCESSOR_PARAMETER_REGEXP) do |matched|
          key = PRE_PROCESSOR_PARAMETER_NAME_REGEXP.match(matched)['token']
          context.fetch(key)
        end
      end
    end
  end
end
