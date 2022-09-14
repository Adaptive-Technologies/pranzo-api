# frozen_string_literal: true

require_relative '../credentials.rb'
RSpec.describe 'GET /admin/vouchers/:id/transactions', type: :request do
  include_context 'credentials'
  let!(:voucher) { create(:voucher) }
  let!(:transactions) do
    3.times { create(:transaction, voucher: voucher) }
  end
  describe 'when logged authenticated as admin' do
    before do
      post "/admin/vouchers/#{voucher.id}/transactions",
           headers: valid_auth_headers_for_admin
    end

    it {
      expect(response).to have_http_status 201
    }

    it 'is expected to include voucher with an updated collection of transactions' do
      expect(response_json['voucher']['transactions'].count).to eq 4
    end
  end
end
