shared_examples_for 'enable globally' do
  before { flags.enable(name) }
end

shared_examples_for 'enable for a user' do
  before { flags.enable(name, type: 'user', id: 1) }
end

shared_examples_for 'enable for a repo' do
  before { flags.enable(name, type: 'repo', id: 1) }
end

shared_examples_for 'enable for a percentage' do
  before { flags.enable(name, percent: 25) }
end

shared_examples_for 'enabled globally' do
  describe 'enabled globally' do
    it { expect(stored['global']).to be true }
    it { expect(cached['global']).to be true }
    it { expect(flags.enabled?(name)).to be true }
  end
end

shared_examples_for 'enabled for the user' do
  describe 'enabled for the user' do
    it { expect(stored['groups']['user']).to eq [1] }
    it { expect(cached['groups']['user']).to eq [1] }
    it { expect(flags.enabled?(name, type: 'user', id: 1)).to be true }
  end
end

shared_examples_for 'enabled for the repo' do
  describe 'enabled for the user' do
    it { expect(stored['groups']['repo']).to eq [1] }
    it { expect(cached['groups']['repo']).to eq [1] }
    it { expect(flags.enabled?(name, type: 'repo', id: 1)).to be true }
  end
end

shared_examples_for 'enabled for the percentage' do
  it { expect(stored['percent']).to eq 25 }
  it { expect(cached['percent']).to eq 25 }
  it { expect(flags.percent(name)).to eq 25 }
end

shared_examples_for 'enable' do
  describe 'enable' do
    let(:key)    { "flags:#{name}" }
    let(:stored) { JSON.parse(client.get(key)) }
    let(:cached) { JSON.parse(cache.get(key)) }

    describe 'globally' do
      describe 'with the flag not previously defined' do
        include_examples 'enable globally'
        include_examples 'enabled globally'
      end

      describe 'with the flag previously enabled globally' do
        include_examples 'enable globally'
        include_examples 'enable globally'
        include_examples 'enabled globally'
      end

      describe 'with the flag previously enabled for a user' do
        include_examples 'enable for a user'
        include_examples 'enable globally'
        include_examples 'enabled for the user'
        include_examples 'enabled globally'
      end

      describe 'with the flag previously enabled for a repo' do
        include_examples 'enable for a repo'
        include_examples 'enable globally'
        include_examples 'enabled for the repo'
        include_examples 'enabled globally'
      end

      describe 'with the flag previously enabled for a percentage' do
        include_examples 'enable for a percentage'
        include_examples 'enable globally'
        include_examples 'enabled for the percentage'
        include_examples 'enabled globally'
      end
    end

    describe 'for a user' do
      describe 'with the flag not previously defined' do
        include_examples 'enable for a user'
        include_examples 'enabled for the user'
      end

      describe 'with the flag previously enabled globally' do
        include_examples 'enable globally'
        include_examples 'enable for a user'
        include_examples 'enabled globally'
        include_examples 'enabled for the user'
      end

      describe 'with the flag previously enabled for a user' do
        include_examples 'enable for a user'
        include_examples 'enable for a user'
        include_examples 'enabled for the user'
      end

      describe 'with the flag previously enabled for a repo' do
        include_examples 'enable for a repo'
        include_examples 'enable for a user'
        include_examples 'enabled for the repo'
        include_examples 'enabled for the user'
      end

      describe 'with the flag previously enabled for a percentage' do
        include_examples 'enable for a percentage'
        include_examples 'enable for a user'
        include_examples 'enabled for the percentage'
        include_examples 'enabled for the user'
      end
    end

    describe 'for a repo' do
      describe 'with the flag not previously defined' do
        include_examples 'enable for a repo'
        include_examples 'enabled for the repo'
      end

      describe 'with the flag previously enabled globally' do
        include_examples 'enable globally'
        include_examples 'enable for a repo'
        include_examples 'enabled globally'
        include_examples 'enabled for the repo'
      end

      describe 'with the flag previously enabled for a user' do
        include_examples 'enable for a user'
        include_examples 'enable for a repo'
        include_examples 'enabled for the user'
        include_examples 'enabled for the repo'
      end

      describe 'with the flag previously enabled for a repo' do
        include_examples 'enable for a repo'
        include_examples 'enable for a repo'
        include_examples 'enabled for the repo'
      end

      describe 'with the flag previously enabled for a percentage' do
        include_examples 'enable for a percentage'
        include_examples 'enable for a repo'
        include_examples 'enabled for the percentage'
        include_examples 'enabled for the repo'
      end
    end

    describe 'percent' do
      describe 'with the flag not previously defined' do
        include_examples 'enable for a percentage'
        include_examples 'enabled for the percentage'
      end

      describe 'with the flag previously enabled globally' do
        include_examples 'enable globally'
        include_examples 'enable for a percentage'
        include_examples 'enabled globally'
        include_examples 'enabled for the percentage'
      end

      describe 'with the flag previously enabled for a user' do
        include_examples 'enable for a user'
        include_examples 'enable for a percentage'
        include_examples 'enabled for the user'
        include_examples 'enabled for the percentage'
      end

      describe 'with the flag previously enabled for a repo' do
        include_examples 'enable for a repo'
        include_examples 'enable for a percentage'
        include_examples 'enabled for the repo'
        include_examples 'enabled for the percentage'
      end

      describe 'with the flag previously enabled for a percentage' do
        include_examples 'enable for a percentage'
        include_examples 'enable for a percentage'
        include_examples 'enabled for the percentage'
      end
    end

    describe 'percent, several users, orgs, and repos' do
      let(:types) { %w(user repo org) }
      before { types.each { |type| 1.upto(3) { |id| flags.enable(name, type: type, id: id) } } }
      before { flags.enable(name, percent: 50) }

      describe 'sets the flag' do
        it { expect(stored['groups']['user']).to eq [1,2,3] }
        it { expect(stored['groups']['repo']).to eq [1,2,3] }
        it { expect(stored['groups']['org']).to eq [1,2,3] }
        it { expect(stored['percent']).to eq 50 }
      end

      describe 'caches the flag' do
        it { expect(cached['groups']['user']).to eq [1,2,3] }
        it { expect(cached['groups']['repo']).to eq [1,2,3] }
        it { expect(cached['groups']['org']).to eq [1,2,3] }
        it { expect(cached['percent']).to eq 50 }
      end

      describe 'reads the flag' do
        it { expect(flag.groups[:user]).to eq [1,2,3] }
        it { expect(flag.groups[:repo]).to eq [1,2,3] }
        it { expect(flag.groups[:org]).to eq [1,2,3] }
        it { expect(flag.percent).to eq 50 }
      end
    end
  end
end
