# frozen_string_literal: true

RSpec.describe 'GET /api/vendors/:id', type: :request do
  let(:vendor) { create(:vendor, name: 'The Restaurant') }
  let(:affiliate_1) { create(:vendor)}
  let(:affiliate_2) { create(:vendor)}

  describe '' do
    before do
      vendor.affiliates << affiliate_1
      vendor.affiliates << affiliate_2
      get "/api/vendors/#{vendor.id}"
    end

    it {
      expect(response).to have_http_status 200
    }

    it 'is expected to return vendor object' do
      expect(response_json['vendor'])
        .to have_key('name')
        .and have_value('The Restaurant')
    end

    it 'is expected to include affiliates' do
      expect(response_json['vendor']['affiliates'].size)
        .to eq 2
    end
  end
end
