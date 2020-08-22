# frozen_string_literal: true

RSpec.describe 'POST /api/services', type: :request do
  describe 'at evening' do
    before do
      Timecop.freeze(Time.local(2020, 1, 1, 17, 01, 0))
      get '/api/services'
    end

    it {
      expect(response).to have_http_status 200
    }

    it 'includes "dinner"' do
      expect(response_json['services']).to include 'dinner'
    end
  end

  describe 'at lunch' do
    before do
      Timecop.freeze(Time.local(2020, 1, 1, 11, 31, 0))
      get '/api/services'
    end

    it {
      expect(response).to have_http_status 200
    }
    it 'includes "lunch"' do
      expect(response_json['services']).to include 'lunch'
    end
  end
end
