# frozen_string_literal: true

require_relative './credentials'
RSpec.describe 'GET /api/vendor/:vendor_id/vouchers/:voucher_id/transactions', type: :request do
  include_context 'credentials'
  describe 'servings voucher' do
    let!(:voucher) { create(:servings_voucher, pass_kit_id: 'qwerty') }
    let!(:transactions) do
      3.times { create(:transaction, voucher: voucher) }
    end
    before do
      post "/api/vendors/#{vendor.id}/vouchers/#{voucher.id}/transactions",
           headers: valid_auth_headers_for_vendor_user
    end

    it {
      expect(response).to have_http_status 201
    }

    it 'is expected to include voucher with an updated collection of transactions' do
      expect(response_json['voucher']['transactions'].count).to eq 4
    end

    it 'is expected to make a call to API burn points endpoint' do
      expect(a_request(:put, 'https://api.pub1.passkit.io/members/member/points/burn')
      .with(body: hash_including({ externalId: '12345', points: 1 }))).to have_been_made.once
    end
  end

  describe 'cash voucher' do
    let(:voucher) { create(:cash_voucher, active: true, value: 500, pass_kit_id: 'qwerty') }

    before do
      post "/api/vendors/#{vendor.id}/vouchers/#{voucher.id}/transactions",
           params: { value: 300 },
           headers: valid_auth_headers_for_vendor_user
    end

    it {
      expect(response).to have_http_status 201
    }

    it 'is expected to include voucher with an updated collection of transactions' do
      expect(response_json['voucher']['transactions'].count).to eq 1
    end

    it 'is expected to reduce voucher value with 300' do
      expect(Voucher.last.current_value).to eq 200
    end

    it 'is expected to make a call to API burn points endpoint' do
      expect(a_request(:put, 'https://api.pub1.passkit.io/members/member/points/burn')
      .with(body: hash_including({ externalId: '12345', points: '300' }))).to have_been_made.once
    end
  end

  describe 'cash voucher with zeor current value' do
    let(:voucher) { create(:cash_voucher, active: true, value: 100) }
    let!(:transaction) {create(:transaction, voucher: voucher, amount: 100)}

    before do
      post "/api/vendors/#{vendor.id}/vouchers/#{voucher.id}/transactions",
           params: { value: 300 },
           headers: valid_auth_headers_for_vendor_user
    end

    it {
      binding.pry
      expect(response).to have_http_status 422
    }

  end
end
