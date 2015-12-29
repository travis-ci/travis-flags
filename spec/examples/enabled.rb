shared_examples_for 'enabled?' do
  describe 'enabled?' do
    describe 'is false by default' do
      subject { flags.enabled?(name) }
      it { should eq false }
    end

    describe 'with no subject given' do
      subject { flags.enabled?(name) }

      describe 'if the flag is enabled globally' do
        before { flags.enable(name) }
        it { should eq true }
      end

      describe 'if the flag is enabled for a user' do
        before { flags.enable(name, type: 'user', id: 1) }
        it { should eq false }
      end

      describe 'if the flag is enabled for the repo' do
        before { flags.enable(name, type: 'repo', id: 1) }
        it { should eq false }
      end

      describe 'if the flag is not enabled for the percentage' do
        before { flags.enable(name, percent: 0) }
        it { should eq false }
      end

      describe 'if the flag is enabled for the percentage' do
        before { flags.enable(name, percent: 100) }
        it { should eq false }
      end
    end

    describe 'with a user given' do
      subject { flags.enabled?(name, type: 'user', id: 1) }

      describe 'if the flag is enabled globally' do
        before { flags.enable(name) }
        it { should eq true }
      end

      describe 'if the flag is enabled for the user' do
        before { flags.enable(name, type: 'user', id: 1) }
        it { should eq true }
      end

      describe 'if the flag is enabled for the repo' do
        before { flags.enable(name, type: 'repo', id: 1) }
        it { should eq false }
      end

      describe 'if the flag is not enabled for the percentage' do
        before { flags.enable(name, percent: 0) }
        it { should eq false }
      end

      describe 'if the flag is enabled for the percentage' do
        before { flags.enable(name, percent: 100) }
        it { should eq true }
      end
    end
  end
end
