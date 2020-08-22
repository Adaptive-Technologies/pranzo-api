# frozen_string_literal: true

describe Items::ShowSerializer, type: :serializer do
  let(:item) { create(:item) }
  let(:serialization) do
    ActiveModelSerializers::SerializableResource.new(
      item,
      serializer: described_class
    )
  end
  subject { JSON.parse(serialization.to_json) }

  it 'is expected to wrap content in key reflecting model name' do
    expect(subject.keys).to match ['item']
  end
  it 'is expected to contain relevant keys' do
    expected_keys = %w[id product_id name price]
    expect(subject['item'].keys).to match expected_keys
  end

  it 'is expected to have a specific structure' do
    expect(subject).to match(
      'item' => {
        'id' => an_instance_of(Integer),
        'product_id' => an_instance_of(Integer),
        'name' => an_instance_of(String),
        'price' => an_instance_of(String)
      }
    )
  end
end