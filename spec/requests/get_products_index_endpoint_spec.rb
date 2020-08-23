# frozen_string_literal: true

RSprc.describe 'GET /api/products', type: :request do

  describe 'at noonish' do
    before do
      Timecop.freeze(Time.local(2020, 1, 1, 12, 1, 0))
    end
    it 'is expected to return products for lunch service' do

    end
  end

  describe 'at afternoon' do
    before do
      Timecop.freeze(Time.local(2020, 1, 1, 12, 1, 0))
    end
    it 'is expected to return products for dinner service' do

    end
  end
end
