module Travis
  class Flags
    class Filters < Struct.new(:filters)
      def apply(object)
        filters.inject(object) do |object, filter|
          filter.apply?(object) ? filter.apply(object) : object
        end
      end

      private

        def filters
          @filters ||= Array(super).compact.map { |name| Filter[name].new }
        end
    end
  end
end

require 'travis/flags/filters/active_record'
require 'travis/flags/filters/sequel'
