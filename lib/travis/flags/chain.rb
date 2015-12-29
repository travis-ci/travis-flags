module Travis
  class Flags
    class Chain
      attr_reader :backends, :logger

      def initialize(map, types, config)
        @backends = types.map { |type| Backend.for(type, map, config) }
        @logger = config[:logger] || Logger.new(STDOUT)
      end

      def define(*args)
        backends.each { |backend| backend.define(*args) if backend.respond_to?(:define) }
        true
      end

      def undefine(*args)
        backends.each { |backend| backend.undefine(*args) if backend.respond_to?(:undefine) }
        true
      end

      def enable(*args)
        backends.each { |backend| backend.enable(*args) }
        true
      end

      def disable(*args)
        backends.each { |backend| backend.disable(*args) }
        true
      end

      def enabled?(*args)
        with_backends do |backend|
          !!backend.enabled?(*args)
        end
      end

      def percent(*args)
        with_backends do |backend|
          backend.percent(*args)
        end
      end

      def flags
        with_backends do |backend|
          backend.flags
        end
      end

      def flag(name)
        with_backends do |backend|
          backend.flag(name)
        end
      end

      private

        def with_backends(&block)
          with_fallback(backends.dup, &block)
        end

        def with_fallback(backends)
          yield backends.shift
        rescue Backend::Error => e
          logger.error [e.message, e.backtrace].flatten.join("\n")
          retry if backends.any?
          raise
        end
    end
  end
end
