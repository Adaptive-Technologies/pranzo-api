# frozen_string_literal: true

require_relative './credentials'
RSpec.describe 'GET /api/vendors/:vendor_id/vouchers', type: :request do
  include_context 'credentials'
  let(:another_vendor) { create(:vendor) }
  let!(:active_affiliate_vouchers) do
    5.times do
      create(:cash_voucher, issuer: another_vendor.system_user, active: true, value: 250, affiliate_network: true)
    end
  end
  let!(:inactive_affiliate_vouchers) do
    5.times do
      create(:cash_voucher, issuer: another_vendor.system_user, active: false, value: 250, affiliate_network: true)
    end
  end
  let!(:s_vouchers) { 5.times { create(:servings_voucher, issuer: vendor_user, active: true) } }
  let!(:c_vouchers) do
    5.times do
      create(:cash_voucher, issuer: vendor_user, active: true, value: [250, 500, 1009].sample)
    end
  end
  let!(:other_vouchers) { 5.times { create(:voucher, active: true) } }
  let!(:transactions) do
    servings_vouchers_collection = Voucher.where(variant: 'servings')
    cash_vouchers_collection = Voucher.where(variant: 'cash')
    5.times do
      create(:transaction, voucher: servings_vouchers_collection[rand(0...4)])
    end
    5.times do
      create(:transaction, voucher: cash_vouchers_collection[rand(0...4)], amount: [50, 75].sample)
    end
  end

  describe 'without affiliation' do
    before do
      get "/api/vendors/#{vendor.id}/vouchers",
          headers: valid_auth_headers_for_vendor_user.merge!(LNG:"sv")
    end
    it {
      expect(response).to have_http_status 200
    }

    it 'is expected to include collection of vouchers' do
      expect(response_json['vouchers'].count).to eq 10
    end
  end

  describe 'with affiliation' do
    let!(:affiliation) { Affiliation.create(vendor: another_vendor, affiliate: vendor) }
  
    before do
      vendor.reload  # Ensure vendor is loaded correctly
      another_vendor.reload  # Ensure another_vendor is loaded correctly
      get "/api/vendors/#{vendor.id}/vouchers",
          headers: valid_auth_headers_for_vendor_user
    end
  
    it {
      expect(response).to have_http_status 200
    }
  
    it 'is expected to include collection of vouchers' do
      expect(response_json['vouchers'].count).to eq 15
    end
  end
end
