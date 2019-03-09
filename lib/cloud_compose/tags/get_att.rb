require_relative 'base'

module CloudCompose
  module Tags
    class GetAtt < Base
      def type_from_coder(_coder)
        :seq
      end

      def value_from_coder(coder)
        case coder.type
        when :seq
          coder.seq
        when :scalar
          coder.scalar.split('.', 2)
        else
          InvalidTypeError.new(coder.tag, coder.type)
        end
      end
    end
  end
end
