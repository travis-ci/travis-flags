require 'travis/flags/filters/filter'

module Travis
  class Flags
    class Filters
      class ActiveRecord < Filter
        register :active_record

        def apply?(object)
          defined?(::ActiveRecord) && object.is_a?(::ActiveRecord::Base)
        end

        def apply(object)
          attrs = { id: object.id, type: type_name(object) }
          attrs.merge(object.attributes.select { |k, v| k =~ /_(id|type)/ }.symbolize_keys)
        end
      end
    end
  end
end
