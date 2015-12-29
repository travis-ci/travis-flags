module Travis
  class Flags
    class Map
      def <<(block)
        mappings << block
      end

      def expand(data)
        data ? [nil, data] + map(data) : [nil]
      end

      private

        def mappings
          @mappings ||= []
        end

        def map(data)
          mappings.map { |mapping| mapping.call(data) }.compact
        end
    end
  end
end
