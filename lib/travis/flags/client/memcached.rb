begin
  require 'dalli'
rescue LoadError
end

module Travis
  class Flags
    class Client
      class Memcached < Client
        register :memcached

        ERRORS = [Dalli::RingError]
        POOL   = { size: 5, timeout: 3 }

        [:get, :set, :delete].each do |name|
          define_method(name) do |*args|
            client.send(name, *args)
          end
        end

        def keys(prefix)
          raise Error.new('Cannot list keys with memcached.')
        end

        def errors
          ERRORS
        end

        private

          def client
            @client ||= opts.respond_to?(:get) ? opts : Dalli::Client.new(opts[:servers], opts[:options] || {})
          end
      end
    end
  end
end
