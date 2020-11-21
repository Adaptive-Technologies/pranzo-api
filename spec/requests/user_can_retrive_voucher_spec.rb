# frozen_string_literal: true

RSpec.describe 'GET /api/vouchers/:code', type: :request do
  before do
    allow(SecureRandom).to receive(:alphanumeric).with(5).and_return('test1')
  end
  
  describe 'with a valid code' do
    let!(:voucher) { create(:voucher) }
    before do
      get "/api/vouchers/#{voucher.code}"
    end

    it {
      expect(response).to have_http_status 200
    }

    it 'is expected to return voucher details' do
      expect(response_json['voucher'].keys)
        .to match %w[id code paid value current_value transactions]
    end
  end

  describe 'with an invalid code' do
    before do
      get "/api/vouchers/xxxxx"
    end

    it {
      expect(response).to have_http_status 404
    }

    it 'is expected to return voucher details' do
      expect(response_json['message'])
        .to eq 'The voucher code is invalid, try again.'
    end
  end
end
