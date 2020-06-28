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

end
