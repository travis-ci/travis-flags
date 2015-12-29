require 'travis/support/helpers/string'
require 'travis/support/registry'

module Travis
  class Flags
    class Client < Struct.new(:opts)
      include Registry
    end
  end
end

require 'travis/flags/client/db'
require 'travis/flags/client/memcached'
require 'travis/flags/client/redis'
