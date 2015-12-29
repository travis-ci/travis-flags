shared_examples 'features' do |type|
  let(:name)   { :foo }
  let(:user)   { User.new(id: 1) }
  let(:repo)   { Repo.new(id: 1, owner: user) }
  let(:cache)  { flags.chain.backends.first.cache }
  let(:flag)   { flags.flag(name) }
  let(:filter) { nil }

  include_examples 'read', type
  include_examples 'define'
  include_examples 'disable'
  include_examples 'disabled?'
  include_examples 'enable'
  include_examples 'enabled?'
  include_examples 'filter'
  include_examples 'map'
end

describe Travis::Flags, 'using redis', redis: true do
  let(:client) { $redis }
  let(:flags)  { described_class.new(:redis, filter: filter, logger: logger, redis: client) }
  include_examples 'features'
end

describe Travis::Flags, 'using active_record', db: true do
  let(:client) { Travis::Flags::Client::Db.new(adapter: :active_record) }
  let(:flags)  { described_class.new(:db, filter: filter, logger: logger) }
  include_examples 'features'
end

describe Travis::Flags, 'using sequel', db: true do
  let(:client) { Travis::Flags::Client::Db.new(adapter: :sequel, connection: $sequel) }
  let(:flags)  { described_class.new(:db, db: { adapter: :sequel, connection: $sequel }, filter: :active_record, logger: logger) }
  include_examples 'features'
end

describe Travis::Flags, 'using memcached', memcached: true do
  let(:client) { $dalli }
  let(:flags)  { described_class.new(:memcached, filter: :active_record, logger: logger, memcached: client) }
  include_examples 'features', :memcached
end

describe Travis::Flags, 'using a chain with redis and postgres', db: true, redis: true do
  let(:client) { $redis }
  let(:flags)  { described_class.new(:redis, :db, filter: :active_record, logger: logger, redis: client) }
  include_examples 'features'
end
