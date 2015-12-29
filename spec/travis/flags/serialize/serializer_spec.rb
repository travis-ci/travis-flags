# describe Travis::Flags::Serializer::String do
#   let(:global)  { true }
#   let(:percent) { 50 }
#   let(:groups)  { { user: [1, 2, 3], repo: [2, 3, 4] } }
#   let(:flag)    { Travis::Flags::Flag.new(global: global, percent: percent, groups: groups) }
#
#   subject { described_class.new(flag).run }
#
#   it { expect(subject).to eq 'global=true&percent=50&user=1,2,3&repo=2,3,4' }
# end
