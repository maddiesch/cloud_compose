module CloudCompose
  module Tags
    class InvalidTypeError < StandardError
      attr_reader :tag
      attr_reader :type

      def initialize(tag, type)
        @tag = tag
        @type = type
        super("Invalid Type (#{type}) for tag `#{tag}`")
      end
    end

    class Base
      attr_reader :type

      attr_reader :value

      def type_from_coder(coder)
        coder.type
      end

      def value_from_coder(_coder)
        raise NotImplementedError, "Missing #{__method__} override."
      end

      def init_with(coder)
        initialize(
          type_from_coder(coder),
          value_from_coder(coder)
        )
      end

      def encode_with(coder)
        coder.send("#{type.to_sym}=", value)
      end

      private

      def initialize(type, value)
        @type = type
        @value = value
      end
    end
  end
end
