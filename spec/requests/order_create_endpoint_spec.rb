# frozen_string_literal: true

RSpec.describe 'POST /api/orders' do
  let(:channells) {
    ActionCable.server.pubsub.instance_variable_get(:@channels_data)
  }
  before do
    ActionCable.server.restart
    post '/api/orders'
  end

  it {
    expect(response).to have_http_status 200
  }
  it 'is expected to create an instance of Order' do
    expect(Order.last).to be_persisted
  end

  it 'is expected to retun the order' do
    expect(response_json['order']).to eq Order.last.as_json
  end

  it 'is expected to retun a success message' do
    expect(response_json['message']).to eq 'Your order was submitted'
  end

  it 'is expected to dispatch a websocket message to "kitchen_notifications"' do
    expect(
      channells["kitchen_notifications"].count
    ).to eq 1
  end

  it 'is expected to include "incoming order" websocket message' do
    time = DateTime.now.in_time_zone .to_s(:time)
    expect(
      JSON.parse(
        channells["kitchen_notifications"].first
      )['data']['message']
    ).to eq "#{time}: incoming order"
  end
end
