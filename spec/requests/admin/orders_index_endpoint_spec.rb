# frozen_string_literal: true

RSpec.describe 'GET /api/admin/orders', type: :request do
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

  before do
    get '/admin/orders'
  end

  it {
    expect(response).to have_http_status 200
  }

  it 'is expected to retun the order' do
    expect(response_json['orders'].count).to eq 2
  end
end
