require_relative 'base'

module CloudCompose
  module Tags
    class SequencedType < Base
      def value_from_coder(coder)
        case coder.type
        when :seq
          coder.seq
        else
          raise InvalidTypeError.new(coder.tag, coder.type)
        end
      end
    end
  end
end
