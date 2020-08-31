# frozen_string_literal: true

describe Products::ShowSerializer, type: :serializer do
  let(:product) { create(:product, subtitle: 'English subtitle') }
  let!(:translations) { product.update(subtitle: 'Swedish subtitle', locale: :sv) }
  let(:serialization) do
    ActiveModelSerializers::SerializableResource.new(
      product,
      serializer: described_class
    )
  end
  subject { JSON.parse(serialization.to_json) }

  it 'is expected to wrap content in key reflecting model name' do
    expect(subject.keys).to match ['product']
  end

  it 'is expected to contain relevant keys' do
    expected_keys = %w[id title subtitle price imageUrl]
    expect(subject['product'].keys).to match expected_keys
  end

  it 'is expected to have a specific structure including translations' do
    expect(subject).to match(
      'product' => {
        'id' => an_instance_of(Integer),
        'title' => an_instance_of(String),
        'imageUrl' => an_instance_of(String),
        'price' => an_instance_of(String),
        'subtitle' => {
          'sv' => an_instance_of(String),
          'en' => an_instance_of(String)
        }
      }
    )
  end
end
