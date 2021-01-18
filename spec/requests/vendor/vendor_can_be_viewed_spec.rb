# frozen_string_literal: true

RSpec.describe 'GET /api/vendors/:id', type: :request do
  let(:vendor) { create(:vendor, name: 'The Restaurnat') }

  describe '' do
    before do
      get "/api/vendors/#{vendor.id}"
    end

    it {
      expect(response).to have_http_status 200
    }

    it 'is expected to return vendor object' do
      expect(response_json['vendor'])
        .to have_key('name')
        .and have_value('The Restaurnat')
    end
  end
end
