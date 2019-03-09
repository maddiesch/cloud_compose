require_relative 'base'

module CloudCompose
  module Tags
    class MapType < Base
      def value_from_coder(coder)
        case coder.type
        when :map
          coder.map
        else
          raise InvalidTypeError.new(coder.tag, coder.type)
        end
      end
    end
  end
end
