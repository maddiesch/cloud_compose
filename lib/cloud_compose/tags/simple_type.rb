require_relative 'map_type'
require_relative 'scalar_type'
require_relative 'sequenced_type'

module CloudCompose
  module Tags
    class And < SequencedType; end
    class Base64 < ScalarType; end
    class Cidr < SequencedType; end
    class Condition < ScalarType; end
    class Equals < SequencedType; end
    class FindInMap < SequencedType; end
    class GetAzs < ScalarType; end
    class If < SequencedType; end
    class ImportValue < ScalarType; end
    class Join < SequencedType; end
    class Not < SequencedType; end
    class Or < SequencedType; end
    class Ref < ScalarType; end
    class Select < SequencedType; end
    class Split < SequencedType; end
    class Transform < MapType; end
  end
end
