describe Users::ShowSerializer, type: :serializer do
  describe 'user serializer for student' do
    let(:user) { create(:user) }
    let(:serialization) { described_class.new(user) }
    subject { JSON.parse(serialization.to_json) }

    it 'contains relevant keys' do
      expected_keys = %w[id email name]
      expect(subject.keys).to match expected_keys
    end
  end
end