require 'travis/flags'

method = ARGV.first == 'on' ? :activate : :deactivate
Travis::Flags.new(:redis).send(method, :feature)
