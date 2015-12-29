# describe Travis::Flags::Deserializer::String do
#   subject { described_class.new(string).run.to_h }
#
#   describe 'global given' do
#     describe 'global turned on' do
#       let(:string) { 'global=true' }
#       it { expect(subject[:global]).to eq(true) }
#     end
#
#     describe 'global turned off' do
#       let(:string) { 'global=false' }
#       it { expect(subject[:global]).to eq(false) }
#     end
#   end
#
#   describe 'percent given' do
#     describe 'percent -1' do
#       let(:string) { 'percent=-1' }
#       it { expect(subject[:percent]).to eq(-1) }
#     end
#
#     describe 'percent 0' do
#       let(:string) { 'percent=0' }
#       it { expect(subject[:percent]).to eq(0) }
#     end
#
#     describe 'percent 100' do
#       let(:string) { 'percent=100' }
#       it { expect(subject[:percent]).to eq(100) }
#     end
#   end
#
#   describe 'one group given' do
#     describe 'group with one id' do
#       let(:string) { 'user=1' }
#       it { expect(subject[:groups][:user]).to eq([1]) }
#     end
#
#     describe 'group with many ids' do
#       let(:string) { 'user=1,2,3' }
#       it { expect(subject[:groups][:user]).to eq([1, 2, 3]) }
#     end
#   end
#
#   describe 'two groups given' do
#     describe 'groups with one id' do
#       let(:string) { 'user=1&repo=1' }
#       it { expect(subject[:groups][:user]).to eq([1]) }
#       it { expect(subject[:groups][:repo]).to eq([1]) }
#     end
#
#     describe 'groups with many ids' do
#       let(:string) { 'user=1,2,3&repo=2,3,4' }
#       it { expect(subject[:groups][:user]).to eq([1, 2, 3]) }
#       it { expect(subject[:groups][:repo]).to eq([2, 3, 4]) }
#     end
#   end
#
#   describe 'global and percent given' do
#     let(:string) { 'global=true&percent=50' }
#     it { expect(subject[:global]).to eq(true) }
#     it { expect(subject[:percent]).to eq(50) }
#   end
#
#   describe 'global and groups given' do
#     let(:string) { 'global=true&user=1,2,3&repo=2,3,4' }
#     it { expect(subject[:global]).to eq(true) }
#     it { expect(subject[:groups][:user]).to eq([1, 2, 3]) }
#     it { expect(subject[:groups][:repo]).to eq([2, 3, 4]) }
#   end
#
#   describe 'percent and groups given' do
#     let(:string) { 'percent=50&user=1,2,3&repo=2,3,4' }
#     it { expect(subject[:percent]).to eq(50) }
#     it { expect(subject[:groups][:user]).to eq([1, 2, 3]) }
#     it { expect(subject[:groups][:repo]).to eq([2, 3, 4]) }
#   end
#
#   describe 'global, percent, and groups given' do
#     let(:string) { 'global=true&percent=50&user=1,2,3&repo=2,3,4' }
#     it { expect(subject[:global]).to eq(true) }
#     it { expect(subject[:percent]).to eq(50) }
#     it { expect(subject[:groups][:user]).to eq([1, 2, 3]) }
#     it { expect(subject[:groups][:repo]).to eq([2, 3, 4]) }
#   end
# end
