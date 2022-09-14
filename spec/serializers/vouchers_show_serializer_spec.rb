# frozen_string_literal: true

describe Vouchers::ShowSerializer, type: :serializer do
  let!(:owner) { create(:owner, voucher: voucher) }
  let(:voucher) { create(:voucher) }
  let(:serialization) do
    ActiveModelSerializers::SerializableResource.new(
      voucher,
      serializer: described_class
    )
  end
  subject { JSON.parse(serialization.to_json) }

  it 'is expected to wrap content in key reflecting model name' do
    expect(subject.keys).to match ['voucher']
  end
  
  it 'is expected to contain relevant keys' do
    expected_keys = %w[id code active value current_value email transactions]
    expect(subject['voucher'].keys).to match expected_keys
  end

  it 'is expected to have a specific structure' do
    expect(subject).to match(
      'voucher' => {
        'id' => an_instance_of(Integer),
        'active' => an_instance_of(FalseClass),
        'code' => an_instance_of(String),
        'current_value' => an_instance_of(Integer),
        'email' => a_string_including('@'),
        'value' => an_instance_of(Integer),
        'transactions' => an_instance_of(Array)
      }
    )
  end
end
