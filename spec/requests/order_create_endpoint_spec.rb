# frozen_string_literal: true

RSpec.describe 'POST /api/orders', type: :request do
  let(:product_1) { create(:product, price: 10) }
  let(:product_2) { create(:product, price: 5) }
  let(:product_3) { create(:product) }
  before do
    ActionCable.server.restart
  end
  describe 'as visitor' do
    before do
      post '/api/orders',
           params: { order: { items: [product_1.id, product_2.id] } }
    end

    it {
      expect(response).to have_http_status 200
    }
    it 'is expected to create an instance of Order' do
      expect(Order.last).to be_persisted
    end

    it 'is expected to have a total calculated on the items' do
      expect(Order.last.total.to_f).to eq 15.00
    end

    it 'is expected to retun the order' do
      expect(response_json['order']).to eq Order.last.as_json
    end

    it 'is expected to retun a success message' do
      expect(response_json['message']).to eq 'Your order was submitted'
    end

    it 'is expected to dispatch a websocket message to "kitchen_notifications"' do
      expect(
        channells['kitchen_notifications'].count
      ).to eq 1
    end

    it 'is expected to include "incoming order" in websocket message' do
      time = DateTime.now.in_time_zone .to_s(:time)
      expect(
        JSON.parse(
          channells['kitchen_notifications'].first
        )['data']['message']
      ).to eq "#{time}: incoming order"
    end
  end

  describe 'as registered user' do
    let(:user) { create(:user) }
    let(:credentials) { user.create_new_auth_token }
    let(:valid_auth_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }

    before do
      post '/api/orders',
           params: { order: { items: [product_3.id, product_2.id] } },
           headers: valid_auth_headers
    end

    it {
      expect(response).to have_http_status 200
    }
    it 'is expected to asociate user with the instance of Order' do
      expect(Order.last.user).to an_instance_of User
    end

    it 'is expected to retun the order with user_id attribute' do
      expect(response_json['order']['user_id']).to eq user.id
    end

    it 'is expected to dispatch a websocket message to "kitchen_notifications"' do
      expect(
        channells['kitchen_notifications'].count
      ).to eq 1
    end

    it 'is expected to include "incoming order from :user.name" in websocket message' do
      time = DateTime.now.in_time_zone .to_s(:time)
      expect(
        JSON.parse(
          channells['kitchen_notifications'].first
        )['data']['message']
      ).to eq "#{time}: incoming order from #{user.name}"
    end
  end
end
