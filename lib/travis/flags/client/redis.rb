begin
  require 'redis'
rescue LoadError
end

module Travis
  class Flags
    class Client
      class Redis < Client
        register :redis

        ERRORS = [::Redis::BaseError]
        POOL   = { size: 1, timeout: 3 }

        [:get, :set, :del].each do |name|
          define_method(name) do |*args|
            client.send(name, *args)
          end
        end

        def keys(prefix)
          keys = []
          client.scan_each(match: "#{prefix}:*") { |key| keys.unshift(key) }
          keys
        end

        def errors
          ERRORS
        end

        private

          def client
            @client ||= opts.respond_to?(:get) ? opts : ::Redis.new(opts)
          end
      end
    end
  end
end
