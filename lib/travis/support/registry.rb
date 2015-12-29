module Travis
  module Registry
    def self.included(base)
      base.send(:extend, ClassMethods)
      base.send(:include, InstanceMethods)
      base.instance_variable_set(:@registry, {})
    end

    module ClassMethods
      attr_reader :registry_key

      def [](key)
        key && registry[key.to_sym] || fail("can not use unregistered object #{key.inspect}. known objects are: #{registry.keys.inspect}")
      end

      def register(key)
        @registry_key = key
        registry[key] = self
      end

      def registry
        const = self
        const = superclass until const.instance_variable_defined?(:@registry) || const == Object
        const.instance_variable_get(:@registry)
      end
    end

    module InstanceMethods
      def registry_key
        self.class.registry_key
      end
    end
  end
end
