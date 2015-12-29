shared_examples_for 'disable globally' do
  before { flags.disable(name) }
end

shared_examples_for 'disable for a user' do
  before { flags.disable(name, type: 'user', id: 1) }
end

shared_examples_for 'disable for a repo' do
  before { flags.disable(name, type: 'repo', id: 1) }
end

shared_examples_for 'disable for a percentage' do
  before { flags.disable(name, percent: 25) }
end

shared_examples_for 'disabled globally' do
  describe 'disabled globally' do
    it { expect(stored['global']).to be false }
    it { expect(cached['global']).to be false }
    it { expect(flags.disabled?(name)).to be true }
  end
end

shared_examples_for 'disabled for the user' do
  describe 'disabled for the user' do
    it { expect(stored['groups']['user']).to eq [] }
    it { expect(cached['groups']['user']).to eq [] }
    it { expect(flags.disabled?(name, type: 'user', id: 1)).to be true }
  end
end

shared_examples_for 'disabled for the repo' do
  describe 'disabled for the user' do
    it { expect(stored['groups']['repo']).to eq [] }
    it { expect(cached['groups']['repo']).to eq [] }
    it { expect(flags.disabled?(name, type: 'repo', id: 1)).to be true }
  end
end

shared_examples_for 'disabled for the percentage' do
  it { expect(stored['percent']).to eq nil }
  it { expect(cached['percent']).to eq nil }
  it { expect(flags.percent(name)).to eq nil }
end

shared_examples_for 'disable' do
  describe 'disable' do
    let(:key)    { "flags:#{name}" }
    let(:stored) { JSON.parse(client.get(key)) }
    let(:cached) { JSON.parse(cache.get(key)) }

    describe 'globally' do
      describe 'with the flag not previously defined' do
        include_examples 'disable globally'
        include_examples 'disabled globally'
      end

      describe 'with the flag previously enabled globally' do
        include_examples 'enable globally'
        include_examples 'disable globally'
        include_examples 'disabled globally'
      end

      describe 'with the flag previously enabled for a user' do
        include_examples 'enable for a user'
        include_examples 'disable globally'
        include_examples 'enabled for the user'
        include_examples 'disabled globally'
      end

      describe 'with the flag previously enabled for a repo' do
        include_examples 'enable for a repo'
        include_examples 'disable globally'
        include_examples 'enabled for the repo'
        include_examples 'disabled globally'
      end

      describe 'with the flag previously enabled for a percentage' do
        include_examples 'enable for a percentage'
        include_examples 'disable globally'
        include_examples 'enabled for the percentage'
        include_examples 'disabled globally'
      end
    end

    describe 'for a user' do
      describe 'with the flag not previously defined' do
        include_examples 'disable for a user'
        include_examples 'disabled for the user'
      end

      describe 'with the flag previously enabled globally' do
        include_examples 'enable globally'
        include_examples 'disable for a user'
        include_examples 'enabled globally'
        it { expect(flags.enabled?(name, type: 'user', id: 1)).to be true }
      end

      describe 'with the flag previously enabled for a user' do
        include_examples 'enable for a user'
        include_examples 'disable for a user'
        include_examples 'disabled for the user'
      end

      describe 'with the flag previously enabled for a repo' do
        include_examples 'enable for a repo'
        include_examples 'disable for a user'
        include_examples 'enabled for the repo'
        include_examples 'disabled for the user'
      end

      describe 'with the flag previously enabled for a percentage' do
        include_examples 'enable for a percentage'
        include_examples 'disable for a user'
        include_examples 'enabled for the percentage'
        it { expect(flags.enabled?(name, type: 'user', id: 1)).to be true }
      end
    end

    describe 'for a repo' do
      describe 'with the flag not previously defined' do
        include_examples 'disable for a repo'
        include_examples 'disabled for the repo'
      end

      describe 'with the flag previously enabled globally' do
        include_examples 'enable globally'
        include_examples 'disable for a repo'
        include_examples 'enabled globally'
        it { expect(flags.enabled?(name, type: 'repo', id: 1)).to be true }
      end

      describe 'with the flag previously enabled for a user' do
        include_examples 'enable for a user'
        include_examples 'disable for a repo'
        include_examples 'enabled for the user'
        include_examples 'disabled for the repo'
      end

      describe 'with the flag previously enabled for a repo' do
        include_examples 'enable for a repo'
        include_examples 'disable for a repo'
        include_examples 'disabled for the repo'
      end

      describe 'with the flag previously enabled for a percentage' do
        include_examples 'enable for a percentage'
        include_examples 'disable for a repo'
        include_examples 'enabled for the percentage'
        it { expect(flags.enabled?(name, type: 'repo', id: 1)).to be true }
      end
    end

    describe 'percent' do
      describe 'with the flag not previously defined' do
        include_examples 'disable for a percentage'
        include_examples 'disabled for the percentage'
      end

      describe 'with the flag previously enabled globally' do
        include_examples 'enable globally'
        include_examples 'disable for a percentage'
        include_examples 'enabled globally'
        include_examples 'disabled for the percentage'
      end

      describe 'with the flag previously enabled for a user' do
        include_examples 'enable for a user'
        include_examples 'disable for a percentage'
        include_examples 'enabled for the user'
        include_examples 'disabled for the percentage'
      end

      describe 'with the flag previously enabled for a repo' do
        include_examples 'enable for a repo'
        include_examples 'disable for a percentage'
        include_examples 'enabled for the repo'
        include_examples 'disabled for the percentage'
      end

      describe 'with the flag previously enabled for a percentage' do
        include_examples 'enable for a percentage'
        include_examples 'disable for a percentage'
        include_examples 'disabled for the percentage'
      end
    end

    describe 'percent, several users, orgs, and repos' do
      let(:types) { %w(user repo org) }
      before { types.each { |type| 1.upto(3) { |id| flags.enable(name, type: type, id: id) } } }
      before { flags.enable(name, percent: 50) }

      before { types.each { |type| 1.upto(3) { |id| flags.disable(name, type: type, id: id) } } }
      before { flags.disable(name, percent: 50) }

      describe 'sets the flag' do
        it { expect(stored['groups']['user']).to eq [] }
        it { expect(stored['groups']['repo']).to eq [] }
        it { expect(stored['groups']['org']).to eq [] }
        it { expect(stored['percent']).to be nil }
      end

      describe 'caches the flag' do
        it { expect(cached['groups']['user']).to eq [] }
        it { expect(cached['groups']['repo']).to eq [] }
        it { expect(cached['groups']['org']).to eq [] }
        it { expect(cached['percent']).to be nil }
      end

      describe 'reads the flag' do
        it { expect(flag.groups[:user]).to eq [] }
        it { expect(flag.groups[:repo]).to eq [] }
        it { expect(flag.groups[:org]).to eq [] }
        it { expect(flag.percent).to be nil }
      end
    end
  end
end

