require 'logger'
require 'travis/flags/backend'
require 'travis/flags/chain'
require 'travis/flags/flag'
require 'travis/flags/map'
require 'travis/flags/filters'
require 'travis/flags/validate'

module Travis
  class Flags
    include Enumerable

    singleton_class.send(:attr_accessor, :format)
    self.format = :json

    attr_reader :chain, :filters, :logger, :mapping

    def initialize(*types)
      opts     = types.last.is_a?(Hash) ? types.pop.dup : {}
      types    = [:redis] if types.empty?

      @logger  = opts[:logger] || Logger.new(STDOUT)
      @mapping = Map.new
      @chain   = Chain.new(mapping, types, opts)
      @filters = Filters.new(opts[:filter])
    end

    def each(&block)
      all.each(&block)
    end

    def all
      chain.flags
    end

    def flag(name)
      chain.flag(name)
    end
    alias [] flag

    def define(name, data = {})
      chain.define(name, data.merge(defined: true))
    end

    def undefine(name)
      chain.undefine(name)
    end

    def allow(&block)
      mapping << block
    end

    def enable(name, subject = nil)
      chain.enable(name, filter(subject))
    end

    def disable(name, subject = nil)
      chain.disable(name, filter(subject))
    end

    def enabled?(name, subject = nil)
      subject = filter(subject)
      validate(name, subject)
      chain.enabled?(name, subject)
    end

    def disabled?(name, subject = nil)
      not enabled?(name, subject)
    end

    def percent(name)
      chain.percent(name)
    end

    private

      def filter(subject)
        filters.apply(subject)
      end

      def validate(name, subject)
        Validate.new(flag(name), subject, logger).run
      end
  end
end
