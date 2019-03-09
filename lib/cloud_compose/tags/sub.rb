require_relative 'base'

module CloudCompose
  module Tags
    class Sub < Base
      def type_from_coder(_coder)
        :seq
      end

      def value_from_coder(coder)
        case coder.type
        when :seq
          seq = coder.seq.dup
          seq.fill({}, seq.length...2)
        when :scalar
          [coder.scalar, {}]
        else
          raise InvalidTypeError.new(coder.tag, coder.type)
        end
      end
    end
  end
end
