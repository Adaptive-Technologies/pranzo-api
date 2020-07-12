describe Orders::IndexSerializer, type: :serializer do
  let(:user) { create(:user) }

  let(:product_1) { create(:product, price: 10) }
  let(:product_2) { create(:product, price: 5) }
  let(:product_3) { create(:product) }
  let(:order_1) { create(:order) }
  let!(:order_1_item_1) { create(:item, order: order_1, product: product_1) }
  let!(:order_1_item_2) { create(:item, order: order_1, product: product_2) }
  let!(:order_1_item_3) { create(:item, order: order_1, product: product_3) }
  let(:order_2) { create(:order, user: user) }
  let!(:order_2_item_1) { create(:item, order: order_2, product: product_1) }
  let!(:order_2_item_2) { create(:item, order: order_2, product: product_2) }
  let!(:order_2_item_3) { create(:item, order: order_2, product: product_3) }
  let(:serialization) do
    ActiveModelSerializers::SerializableResource.new(
      [order_1, order_2],
      each_serializer: described_class,
      scope: user,
      scope_name: :current_user
    )
  end
  subject { JSON.parse(serialization.to_json) }

  it 'is expected to wrap content in key reflecting model name' do
    expect(subject.keys).to match ['orders']
  end

  it 'is expected to contain relevant keys for each object' do
    expected_keys = %w[id table time user items]
    expect(subject['orders'].last.keys).to match expected_keys
  end

  it '"user" is expected to contain relevant keys' do
    expected_keys = %w[id email name]
    expect(subject['orders'].last['user'].keys).to match expected_keys
  end

  it '"items" is expected to contain relevant keys' do
    expected_keys = %w[id product_id name price]
    expect(subject['orders'].last['items'].first.keys).to match expected_keys
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