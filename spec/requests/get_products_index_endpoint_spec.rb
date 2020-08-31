# frozen_string_literal: true

RSpec.describe 'GET /api/products', type: :request do
  let(:category_1) { create(:category, name: 'Tapas') }
  let(:category_2) { create(:category, name: 'Pica-Pica') }
  let(:category_3) { create(:category, name: 'Drinks') }
  let!(:lunch_dish_1) { create(:product, services: %w[lunch dinner], categories: [category_1, category_2]) }
  let!(:lunch_dish_2) { create(:product, services: ['lunch'], categories: [category_2]) }
  let!(:lunch_dish_3) { create(:product, services: ['lunch'], categories: [category_3]) }
  let!(:dinner_dish) { create(:product, services: ['dinner'], categories: [category_1, category_2]) }

  describe 'at noonish' do
    before do
      category_1.update({ promo: 'Svensk promotext', locale: :sv })
      lunch_dish_1.update({ subtitle: 'Svens subtitle', locale: :sv })
      Timecop.freeze(Time.local(2020, 1, 1, 12, 1, 0))
      get '/api/products'
    end

    it {
      expect(response).to have_http_status 200
    }

    it 'is expected to return products for lunch service' do
      expect(response_json['tapas']['items'].count).to eq 1
    end

    it 'is expected to return translated promo' do
      expect(response_json['tapas']['promo'].keys).to match %w[en sv]
    end

    it 'is expected to return translated subtitle' do
      expect(response_json['tapas']['items'][0]['subtitle'].keys).to match %w[en sv]
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
      expect(response_json['tapas']['items'].count).to eq 1
    end
  end

  describe 'any other time' do # is this really what we want???
    before do
      Timecop.freeze(Time.local(2020, 1, 1, 8, 0, 0))
      get '/api/products'
    end

    it {
      expect(response).to have_http_status 200
    }

    it 'is expected to return all products for both lunch and dinner service' do
      expect(response_json.keys).to eq %w[tapas pica-pica drinks]
    end
  end
end
