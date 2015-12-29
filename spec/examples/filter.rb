shared_examples_for 'filter' do
  describe 'filter' do
    describe 'active_record' do
      let(:filter) { :active_record }
      subject      { flags.enabled?(name, repo) }

      describe 'with the owner mapped' do
        before { flags.allow { |a| { type: a[:owner_type], id: a[:owner_id] } if a[:type] == 'repository' } }

        describe 'if the flag is enabled globally' do
          before { flags.enable(name) }
          it { should eq true }
        end

        describe 'if the flag is enabled for the repo' do
          before { flags.enable(name, repo) }
          it { should eq true }
        end

        describe 'if the flag is enabled for the repo owner' do
          before { flags.enable(name, user) }
          it { should eq true }
        end
      end

      describe 'with the owner not mapped' do
        describe 'if the flag is enabled globally' do
          before { flags.enable(name) }
          it { should eq true }
        end

        describe 'if the flag is enabled for the repo' do
          before { flags.enable(name, repo) }
          it { should eq true }
        end

        describe 'if the flag is enabled for the repo owner' do
          before { flags.enable(name, user) }
          it { should eq false }
        end
      end
    end
  end
end
