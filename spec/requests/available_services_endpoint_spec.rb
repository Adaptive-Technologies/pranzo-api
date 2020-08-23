# frozen_string_literal: true

RSpec.describe 'GET /api/services', type: :request do
  describe 'at evening' do
    before do
      Timecop.freeze(Time.local(2020, 1, 1, 17, 1, 0))
      get '/api/services'
    end

    it {
      expect(response).to have_http_status 200
    }

    it 'is expected to include "dinner"' do
      expect(response_json['services']).to include 'dinner'
    end
  end

  describe 'at lunch time' do
    before do
      Timecop.freeze(Time.local(2020, 1, 1, 11, 31, 0))
      get '/api/services'
    end

    it {
      expect(response).to have_http_status 200
    }
    it 'is expected to include "lunch"' do
      expect(response_json['services']).to include 'lunch'
    end
  end
end
