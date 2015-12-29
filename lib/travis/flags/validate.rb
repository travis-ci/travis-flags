module Travis
  class Flags
    class Validate < Struct.new(:flag, :subject, :logger)
      MSGS = {
        used:    '[travis-flags] Flag used: %s, subject: %s',
        unknown: '[travis-flags] Unknown flag used: %s. Define used flags using flags.define(name, options).',
        expired: '[travis-flags] Expired flag used: %s. Expired: %s. Purpose: %s.'
      }

      def run
        return unknown unless flag.defined?
        return expired if     flag.expired?
        used
      end

      private

        def used
          logger.debug MSGS[:used] % [flag.name, subject.inspect]
        end

        def unknown
          logger.warn MSGS[:unknown] % [flag.name]
        end

        def expired
          logger.warn MSGS[:expired] % [flag.name, flag.expires, flag.purpose]
        end
    end
  end
end
