require_relative 'base'

module CloudCompose
  module Tags
    class Builtin < Base
      def type_from_coder(_coder)
        :scalar
      end

      def value_from_coder(coder)
        case coder.type
        when :scalar
          path = File.expand_path('../builtin', File.dirname(__FILE__))
          path += File::SEPARATOR
          path += coder.scalar
          path
        else
          raise InvalidTypeError.new(coder.tag, coder.type)
        end
      end

      def encode_with(coder)
        coder.tag = nil
        coder.scalar = value
      end

      def to_s
        value
      end
    end
  end
end
