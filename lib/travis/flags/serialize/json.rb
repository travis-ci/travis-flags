require 'json'

module Travis
  class Flags
    module Serialize
      class Json < Serializer
        register :json

        def serialize(obj)
          JSON.dump(obj.to_h)
        end

        def deserialize(string)
          JSON.parse(string)
        end
      end
    end
  end
end
