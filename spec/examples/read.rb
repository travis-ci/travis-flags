shared_examples_for 'a flag' do
  let(:expires) { '2016-08-01' }
  let(:purpose) { 'test!' }

  before { flags.define(name, expires: expires, purpose: purpose) }
  before { flags.enable(name) }
  before { flags.enable(name, type: 'user', id: 1) }
  before { flags.enable(name, percent: 25) }

  it { expect(flag.name).to    eq name }
  it { expect(flag.global).to  be true }
  it { expect(flag.percent).to eq 25 }
  it { expect(flag.groups).to  eq(user: [user.id]) }
  it { expect(flag.expires).to eq expires }
  it { expect(flag.purpose).to eq purpose }
end

shared_examples_for 'read' do |type|
  describe 'all' do
    let(:flag) { flags.all.first }
    include_examples 'a flag' unless type == :memcached
  end

  describe 'flag' do
    let(:flag) { flags.flag(name) }
    include_examples 'a flag'
  end

  describe '[]' do
    let(:flag) { flags[name] }
    include_examples 'a flag'
  end

  describe 'enumerable' do
    before  { [:foo, :bar, :baz].each { |name| flags.define(name) } }
    it { expect(flags.map(&:name)).to eq [:foo, :bar, :baz] } unless type == :memcached
  end
end
