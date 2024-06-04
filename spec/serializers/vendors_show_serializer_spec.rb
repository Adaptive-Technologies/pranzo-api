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
    expected_keys = %w[id name legal_name description primary_email org_id vat_id logotype affiliates users addresses]
    expect(subject['vendor'].keys).to match expected_keys
  end
end
