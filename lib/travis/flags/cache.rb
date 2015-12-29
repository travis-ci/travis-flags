require 'monitor'

module Travis
  class Flags
    class Cache
      class << self
        def new(interval)
          interval == 0 ? Cache::Noop.new : Cache::Memory.new(interval)
        end
      end

      class Noop
        def get(key)
          yield if block_given?
        end

        def set(key, value)
          value
        end

        def del(key, value = nil)
          value
        end
      end

      class Memory
        INTERVAL = 5

        attr_reader :lock, :cache, :interval

        def initialize(interval)
          @cache = {}
          @lock  = Monitor.new
          @interval = interval || INTERVAL
          Thread.new { periodically { flush } }
        end

        def clear
          cache.clear
        end

        def get(key)
          lock.synchronize do
            if cache.key?(key)
              cache[key]
            elsif block_given?
              yield.tap { |result| set(key, result) }
            end
          end
        end

        def set(key, value)
          lock.synchronize do
            cache[key] = value
          end
        end

        def del(key, value = nil)
          lock.synchronize do
            if value
              cache[key].delete(value) if cache.key?(key)
            else
              cache.delete(key)
            end
          end
        end

        private

          def flush
            lock.synchronize do
              clear
            end
          end

          def periodically
            loop do
              sleep interval
              yield
            end
          end
      end
    end
  end
end
