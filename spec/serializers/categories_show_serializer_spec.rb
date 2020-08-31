# frozen_string_literal: true

describe Categories::ShowSerializer, type: :serializer do
  let(:category) { create(:category, promo: 'English promo') }
  let!(:translations) { category.update(promo: 'Swedish promo', locale: :sv) }
  let(:serialization) do
    ActiveModelSerializers::SerializableResource.new(
      category,
      serializer: described_class
    )
  end
  subject { JSON.parse(serialization.to_json) }

  it 'is expected to wrap content in key reflecting model name' do
    expect(subject.keys).to match ['category']
  end

  it 'is expected to contain relevant keys' do
    expected_keys = %w[promo]
    expect(subject['category'].keys).to match expected_keys
  end

  it 'is expected to have a specific structure including translations' do
    expect(subject).to match(
      'category' => {
        'promo' => {
          'sv' => an_instance_of(String),
          'en' => an_instance_of(String)
        }
      }
    )
  end
end
