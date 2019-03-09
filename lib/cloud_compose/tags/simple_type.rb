require_relative 'scalar_type'
require_relative 'sequenced_type'

module CloudCompose
  module Tags
    class Base64 < ScalarType; end
    class Cidr < SequencedType; end
    class FindInMap < SequencedType; end
    class Ref < ScalarType; end
  end
end
