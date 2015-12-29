require 'travis/support/registry'

# msgpack is almost 2.5x as fast, but needs to be compiled
#
# json:     2.130000   0.040000   2.170000 (  2.193625)
# msgpack:  0.830000   0.040000   0.870000 (  0.903370)

module Travis
  class Flags
    module Serialize
      class Serializer
        include Registry
      end

      def serialize(obj)
        Serializer[Flags.format].new.serialize(obj)
      end

      def deserialize(string)
        return {} unless string
        hash = Serializer[Flags.format].new.deserialize(string)
        Hash[hash.map { |key, value| [key.to_sym, value] }]
      end

      extend self
    end
  end
end

require 'travis/flags/serialize/json'
require 'travis/flags/serialize/msgpack'
