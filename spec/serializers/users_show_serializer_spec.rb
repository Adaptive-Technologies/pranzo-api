# frozen_string_literal: true

describe Users::ShowSerializer, type: :serializer do
  let(:user) { create(:user) }
  # let(:serialization) { described_class.new(user) }
  let(:serialization) do
    ActiveModelSerializers::SerializableResource.new(
      user,
      serializer: described_class
    )
  end
  subject { JSON.parse(serialization.to_json) }

  it 'is expected to wrap content in key reflecting model name' do
    expect(subject.keys).to match ['user']
  end
  it 'is expected to contain relevant keys' do
    expected_keys = %w[id email name]
    expect(subject['user'].keys).to match expected_keys
  end

  it 'is expected to have a specific structure' do
    expect(subject).to match(
      'user' => {
        'id' => an_instance_of(Integer),
        'email' => a_string_including('@'),
        'name' => an_instance_of(String)
      }
    )
  end
end
