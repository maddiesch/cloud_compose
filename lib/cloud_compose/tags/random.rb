require 'securerandom'

require_relative 'base'

module CloudCompose
  module Tags
    class Random < Base
      def type_from_coder(_coder)
        :scalar
      end

      def value_from_coder(coder)
        case coder.type
        when :seq
          @random_type = coder.seq[0]
          @random_count = coder.seq[1].to_i
          []
        else
          raise InvalidTypeError.new(coder.tag, coder.type)
        end
      end

      def encode_with(coder)
        coder.tag = nil
        case @random_type
        when 'hex'
          coder.scalar = SecureRandom.hex(@random_count)
        else
          raise ArgumentError, "Invalid Random Type #{@random_type}"
        end
      end
    end
  end
end
