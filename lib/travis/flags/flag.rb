require 'zlib'
require 'travis/support/helpers/string'

module Travis
  class Flags
    class Flag
      include Helpers::String

      ATTRS = [:name, :defined, :global, :percent, :groups, :expires, :purpose]

      attr_accessor *ATTRS

      def initialize(data)
        @name    = data[:name].to_sym if data[:name]
        @defined = data[:defined]
        @global  = data[:global]
        @percent = data[:percent]
        @groups  = symbolize_keys(data[:groups] || {})
        @expires = data[:expires] unless data[:expires].to_s == 'never'
        @purpose = data[:purpose]
      end

      def global
        !!@global
      end

      def defined?
        !!defined
      end

      def define(data)
        @defined = true
        @expires = data[:expires]
        @purpose = data[:purpose]
      end

      def undefine
        @defined = false
        @expires = nil
        @purpose = nil
      end

      def enabled?(data = {})
        self.global || group_enabled?(data) || percent_enabled?(data)
      end

      def enable(data)
        if data.nil?
          self.global = true
        elsif data[:percent]
          self.percent = data[:percent]
        else
          enable_group(data)
        end
      end

      def disable(data)
        if data.nil?
          self.global = false
        elsif data[:percent]
          self.percent = nil
        else
          disable_group(data)
        end
      end

      def expired?
        expires && expires.to_s < Date.today.to_s
      end

      def to_h
        compact(Hash[ATTRS.map { |attr| [attr, instance_variable_get(:"@#{attr}")] }])
      end

      private

        def enable_group(data)
          group = group_for(data)
          group << data[:id] unless group.include?(data[:id])
        end

        def disable_group(data)
          group_for(data).delete(data[:id])
        end

        def group_enabled?(data)
          group_for(data).include?(data[:id]) if data && type_from(data)
        end

        def percent_enabled?(data)
          uid = uid_for(data) if data
          !!uid && uid % 100 < percent.to_i
        end

        def group_for(data)
          groups[type_from(data)] ||= []
        end

        def type_from(data)
          underscore(data[:type]).to_sym if data[:type]
        end

        def uid_for(data)
          uid = data[:id]
          uid.is_a?(String) ? Zlib.crc32(uid).to_i & 0x7fffffff : uid
        end

        def compact(hash)
          hash.reject { |_, value| value.nil? || value.respond_to?(:empty?) && value.empty? }
        end

        def symbolize_keys(hash)
          Hash[hash.map { |key, value| [key.to_sym, value] }] if hash
        end
    end
  end
end
