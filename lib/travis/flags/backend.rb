require 'travis/flags/cache'
require 'travis/flags/client'
require 'travis/flags/serialize'

module Travis
  class Flags
    class Backend
      class Error < StandardError
        attr_reader :error

        MSG = 'Error %sing from backend %s: %s'

        def initialize(backend = nil, cmd = nil, error = nil)
          @error = error
          super(MSG % [cmd, backend, error.message]) if error
        end

        def backtrace
          error.backtrace if error
        end
      end

      include Serialize

      def self.for(type, map, config)
        const = type == :redis_bc ? Backend::Bc : Backend
        const.new(type, map, config || {})
      end

      attr_reader :cache, :client, :map, :config

      def initialize(type, map, config)
        @cache  = Cache.new(config[:cache])
        @client = Client[type].new(config[type] || {})
        @map    = map
        @config = config
      end

      def flags
        names.map { |name| read(name) }
      end

      def flag(name)
        read(name)
      end

      def define(name, data = {})
        flag = read(name)
        flag.define(data)
        write(name, flag)
      end

      def undefine(name)
        flag = read(name)
        flag.undefine
        write(name, flag)
      end

      def enabled?(name, subject = nil)
        flag = read(name)
        subjects = map.expand(subject)
        subjects.any? { |subject| flag.enabled?(subject) }
      end

      def enable(name, subject = nil)
        flag = read(name)
        flag.enable(subject)
        write(name, flag)
      end

      def disable(name, subject = nil)
        flag = read(name)
        flag.disable(subject)
        write(name, flag)
      end

      def percent(name)
        flag = read(name)
        flag.percent
      end

      private

        def names
          keys = client.keys(prefix)
          keys.map { |key| key.sub("#{prefix}:", '') }
        end

        def read(name)
          reraise(:read) do
            data = deserialize(get(name))
            Flag.new(data.merge(name: name))
          end
        end

        def write(name, flag)
          reraise(:write) do
            string = serialize(flag)
            string.empty? ? del(name) : set(name, string)
          end
        end

        def get(name)
          key = key_for(name)
          cache.get(key) { client.get(key) }
        end

        def set(name, string)
          key = key_for(name)
          client.set(key, string)
          cache.set(key, string)
        end

        def del(name)
          client.del(key_for(name))
          cache.del(key, string)
        end

        def key_for(name)
          raise "name is #{name.inspect}" if name.nil? || name.empty?
          [prefix, name].join(':')
        end

        def prefix
          @prefix ||= [config[:prefix] || :flags].join(':')
        end

        def reraise(cmd)
          yield
        rescue *client.errors => e
          raise Error.new(client.class.name.split('::').last, cmd, e)
        end
    end
  end
end
