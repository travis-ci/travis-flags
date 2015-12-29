describe Travis::Flags::Chain, redis: true do
  let(:map)   { Travis::Flags::Map.new }
  let(:types) { [:redis, :db] }
  let(:opts)  { { cache: 0, logger: logger } }
  let(:chain) { Travis::Flags::Chain.new(map, types, opts) }
  let(:redis) { chain.backends.first }
  let(:db)    { chain.backends.last }

  describe 'flags returns distinct objects' do
    before { chain.define(:foo) }
    it { expect(redis.flags.map(&:object_id) & db.flags.map(&:object_id)).to be_empty }
  end

  describe 'define writes to all backends' do
    before { chain.define(:foo) }
    it { expect(redis.flags.map(&:defined?)).to eq [true] }
    it { expect(db.flags.map(&:defined?)).to eq [true] }
  end

  describe 'undefine writes to all backends' do
    before { chain.define(:foo) }
    before { chain.undefine(:foo) }
    it { expect(redis.flags.map(&:defined?)).to eq [false] }
    it { expect(db.flags.map(&:defined?)).to eq [false] }
  end

  describe 'enable writes to all backends' do
    before { chain.enable(:foo) }
    it { expect(redis.flags.map(&:enabled?)).to eq [true] }
    it { expect(db.flags.map(&:enabled?)).to eq [true] }
  end

  describe 'disable writes to all backends' do
    before { chain.enable(:foo) }
    before { chain.disable(:foo) }
    it { expect(redis.flags.map(&:enabled?)).to eq [false] }
    it { expect(db.flags.map(&:enabled?)).to eq [false] }
  end

  shared_examples_for 'fallbacks' do
    let(:error) { Travis::Flags::Backend::Error.new }
    before { redis.client.stubs(:get).raises(error) }

    describe 'falls back to the next backend' do
      it { expect(subject).to_not be_nil }
    end

    describe 'raises if all backends raise' do
      let(:client_error)  { ActiveRecord::ActiveRecordError.new }
      let(:backend_error) { Travis::Flags::Backend::Error.new('Db', :read, client_error) }
      before { db.client.stubs(:get).raises(client_error) }
      it { expect { subject }.to raise_error(backend_error) }
    end
  end

  describe 'enabled?' do
    before  { chain.enable(:foo) }
    subject { chain.enabled?(:foo) }
    it { expect(subject).to be true }
    include_examples 'fallbacks'
  end

  describe 'percent' do
    before  { chain.enable(:foo, percent: 50) }
    subject { chain.percent(:foo) }
    it { expect(subject).to eq 50 }
    include_examples 'fallbacks'
  end

  describe 'flags' do
    before  { chain.enable(:foo) }
    subject { chain.flags }
    it { expect(subject.map(&:name)).to eq [:foo] }
    include_examples 'fallbacks'
  end

  describe 'flag' do
    before  { chain.enable(:foo) }
    subject { chain.flag(:foo) }
    it { expect(subject.name).to eq :foo }
    include_examples 'fallbacks'
  end
end
