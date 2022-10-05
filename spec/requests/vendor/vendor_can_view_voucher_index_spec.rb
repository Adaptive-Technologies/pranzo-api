# frozen_string_literal: true

require_relative './credentials.rb'
RSpec.describe 'GET /api/vendors/:vendor_id/vouchers', type: :request do
  include_context 'credentials'
  let!(:s_vouchers) { 5.times { create(:servings_voucher, issuer: vendor_user, active: true) } }
  let!(:c_vouchers) { 5.times { create(:cash_voucher, issuer: vendor_user, active: true, value: [250, 500, 1009].sample) } }
  let!(:other_vouchers) { 5.times { create(:voucher, active: true) } }
  let!(:transactions) do
    servings_vouchers_collection = Voucher.where(variant: 'servings')
    cash_vouchers_collection = Voucher.where(variant: 'cash')
    5.times do
      create(:transaction, voucher: servings_vouchers_collection[rand(0...4)])
    end
    5.times do
      create(:transaction, voucher: cash_vouchers_collection[rand(0...4)], amount: [50, 120, 210].sample)
    end
  end
    before do
      get "/api/vendors/#{vendor.id}/vouchers",
          headers: valid_auth_headers_for_vendor_user
    end

    it {
      expect(response).to have_http_status 200
    }

    it 'is expected to include collection of vouchers' do
      expect(response_json['vouchers'].count).to eq 10
    end
end
