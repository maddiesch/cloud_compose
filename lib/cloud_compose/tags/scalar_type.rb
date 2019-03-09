require_relative 'base'

module CloudCompose
  module Tags
    class ScalarType < Base
      def value_from_coder(coder)
        case coder.type
        when :scalar
          coder.scalar
        else
          raise InvalidTypeError.new(coder.tag, coder.type)
        end
      end
    end
  end
end
