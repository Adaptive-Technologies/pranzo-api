# frozen_string_literal: true

RSpec.describe 'GET /api/products', type: :request do
  let!(:lunch_dish) { create(:product, services: ['lunch']) }
  let!(:dinner_dish) { create(:product, services: ['dinner']) }

  describe 'at noonish' do
    before do
      Timecop.freeze(Time.local(2020, 1, 1, 12, 1, 0))
      get '/api/products'
    end

    it {
      expect(response).to have_http_status 200
    }

    it 'is expected to return products for lunch service' do
      expect(response_json['products'].count).to eq 1
    end
  end

  describe 'at afternoon' do
    before do
      Timecop.freeze(Time.local(2020, 1, 1, 12, 1, 0))
      get '/api/products'
    end

    it {
      expect(response).to have_http_status 200
    }

    it 'is expected to return products for dinner service' do
      expect(response_json['products'].count).to eq 1
    end
  end
end
