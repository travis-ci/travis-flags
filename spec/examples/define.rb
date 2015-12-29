shared_examples_for 'define' do
  describe 'define' do
    describe 'sets expiry date and purpose' do
      let(:name)    { :baz }
      let(:expires) { '2016-08-01' }
      let(:purpose) { 'test!' }
      before        { flags.define(name, expires: expires, purpose: purpose) }
      it { expect(flag.expires).to eq expires }
      it { expect(flag.purpose).to eq purpose }
    end

    describe 'defining a previously enabled flag' do
      let(:name)    { :baz }
      let(:expires) { :never }
      let(:purpose) { 'test!' }
      before        { flags.enable(name) }
      before        { flags.define(name, expires: expires, purpose: purpose) }
      it { expect(flags.enabled?(name)).to be true }
    end
  end

  describe 'undefine' do
    let(:name) { :baz }
    before     { flags.define(name, expires: '2016-08-01', purpose: 'test!') }
    before     { flags.undefine(name) }
    it { expect(flag.defined?).to be false }
    it { expect(flag.expires).to be_nil }
    it { expect(flag.purpose).to be_nil }
  end
end
