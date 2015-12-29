require 'travis/support/helpers/string'
require 'travis/support/registry'

module Travis
  class Flags
    class Filters
      class Filter
        include Registry, Helpers::String

        def type_name(object)
          underscore(object.class.name.split('::').last)
        end
      end
    end
  end
end
