require 'msgpack'

module Travis
  class Flags
    module Serialize
      class Msgpack < Serializer
        register :msgpack

        def serialize(obj)
          MessagePack.pack(obj.to_h)
        end

        def deserialize(string)
          MessagePack.unpack(string)
        end
      end
    end
  end
end
