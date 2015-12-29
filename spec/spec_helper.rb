require 'travis/flags'
require 'support/require_all'
require_all 'support'
require_all 'examples'

$redis  = Redis.new
$sequel = Sequel.connect('postgres://127.0.0.1/travis_flags_test', pool: 1)
$dalli  = Dalli::Client.new('localhost:11211', expire_after: 20 * 60)

RSpec.configure do |c|
  c.include Support::Database, db: true
  c.include Support::Logger
  c.mock_with :mocha
  c.before(redis: true)     { $redis.flushall }
  c.before(memcached: true) { $dalli.flush_all }
end
