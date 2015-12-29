module Travis
  module Helpers
    module Retrying
      class Retry
        RETRIES = 3
        JITTER  = 0.25

        attr_reader :errors, :options

        def initialize(errors, options)
          @errors  = errors
          @retries = options[:retries] || RETRIES
          @jitter  = options[:jitter]  || JITTER
        end

        def run
          yield
        rescue *errors
          raise if retries -= 1 == 0
          sleep(delay)
          retry
        end

        def delay
          jitter * (rand(2 ** retries - 1) + 1)
        end
      end

      def retrying(*errors, &block)
        options = errors.last.is_a?(Hash) ? errors.pop : {}
        Retries.new(errors, options).run(&block)
      end
    end
  end
end
