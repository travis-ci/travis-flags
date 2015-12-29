shared_examples_for 'disabled?' do
  describe 'disabled?' do
    describe 'is true by default' do
      subject { flags.disabled?(name) }
      it { should eq true }
    end

    describe 'with no subject given' do
      subject { flags.disabled?(name) }

      describe 'if the flag is enabled globally' do
        before { flags.enable(name) }
        it { should eq false }
      end

      describe 'if the flag is enabled for a user' do
        before { flags.enable(name, type: 'user', id: 1) }
        it { should eq true }
      end

      describe 'if the flag is enabled for the repo' do
        before { flags.enable(name, repo) }
        it { should eq true }
      end

      describe 'if the flag is not enabled for the percentage' do
        before { flags.enable(name, percent: 0) }
        it { should eq true }
      end

      describe 'if the flag is enabled for the percentage' do
        before { flags.enable(name, percent: 100) }
        it { should eq true }
      end
    end

    describe 'with a user given' do
      subject { flags.disabled?(name, type: 'user', id: 1) }

      describe 'if the flag is enabled globally' do
        before { flags.enable(name) }
        it { should eq false }
      end

      describe 'if the flag is enabled for the user' do
        before { flags.enable(name, type: 'user', id: 1) }
        it { should eq false }
      end

      describe 'if the flag is enabled for the repo' do
        before { flags.enable(name, repo) }
        it { should eq true }
      end

      describe 'if the flag is not enabled for the percentage' do
        before { flags.enable(name, percent: 0) }
        it { should eq true }
      end

      describe 'if the flag is enabled for the percentage' do
        before { flags.enable(name, percent: 100) }
        it { should eq false }
      end
    end
  end
end
