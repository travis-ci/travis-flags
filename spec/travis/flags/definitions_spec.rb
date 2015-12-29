describe Travis::Flags, 'definitions' do
  let(:user)   { User.new(id: 1) }
  let(:flags)  { described_class.new(:redis, filter: :active_record, logger: logger) }
  let(:expiry) { :never }

  before { flags.define(:foo, expires: expiry, purpose: 'test') }

  describe 'all' do
    subject { flags.all.first }
    it { expect(subject.name).to eq(:foo) }
    it { expect(subject.expires).to be_nil }
    it { expect(subject.purpose).to eq('test') }
  end

  describe 'logs used flags' do
    before { flags.enabled?(:foo) }
    it { expect(stdout).to match(/DEBUG .*\[travis-flags\] Flag used: foo, subject: nil/) }
  end

  describe 'logs used flags (with a subject)' do
    before { flags.enabled?(:foo, user) }
    it { expect(stdout).to match(/DEBUG .*\[travis-flags\] Flag used: foo, subject: {:id=>1, :type=>"user"}/) }
  end

  describe 'warns about using an undefined flag' do
    before { flags.enabled?(:bar) }
    it { expect(stdout).to match(/WARN .*\[travis-flags\] Unknown flag used: bar/) }
  end

  describe 'warns about using an expired flag' do
    let(:expiry) { '2015-01-01' }
    before { flags.enabled?(:foo) }
    it { expect(stdout).to match(/WARN .*\[travis-flags\] Expired flag used: foo. Expired: 2015-01-01. Purpose: test./) }
  end
end
