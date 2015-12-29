require 'travis/flags/filters/filter'

module Travis
  class Flags
    class Filters
      class Sequel < Filter
        register :sequel

        def apply?(object)
          defined?(::Sequel) && object.is_a?(::Sequel::Model)
        end

        def apply(object)
          attrs = { id: object.id, type: type_name(object) }
          attrs.merge(object.values.select { |k, v| k.to_s =~ /_(id|type)/ })
        end
      end
    end
  end
end
