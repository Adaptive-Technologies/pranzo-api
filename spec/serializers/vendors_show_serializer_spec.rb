describe Vendors::ShowSerializer do
  let(:vendor) { create(:vendor) }
  let(:serialization) do
    ActiveModelSerializers::SerializableResource.new(
      vendor,
      serializer: described_class
    )
  end
  subject { JSON.parse(serialization.to_json) }

  it 'is expected to wrap content in key reflecting model name' do
    expect(subject.keys).to match ['vendor']
  end
  
  it 'is expected to contain relevant keys' do
    expected_keys = %w[id name description primary_email affiliates users addresses]
    expect(subject['vendor'].keys).to match expected_keys
  end

  it 'is expected to have a specific structure' do
    expect(subject).to match(
      'vendor' => {
        'id' => an_instance_of(Integer),
        'name' => an_instance_of(String),
        'description' => an_instance_of(String),
        'primary_email' => a_string_including('@'),
        'users' => an_instance_of(Array),
        'addresses' => an_instance_of(Array),
        'affiliates' => an_instance_of(Array)
      }
    )
  end
end
