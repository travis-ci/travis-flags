module Travis
  module Helpers
    module String
      def pluralize(string)
        string.respond_to?(:pluralize) ? string.pluralize : "#{string}s"
      end

      def underscore(string)
        string.to_s.
          gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          downcase
      end

      def camelize(string)
        string.to_s.
          sub(/^[a-z\d]*/) { $&.capitalize }.
          gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }.
          gsub('/', '::')
      end

      extend self
    end
  end
end
