# frozen_string_literal: true

RSpec.describe 'Post /api/orders' do
  before do
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

end
