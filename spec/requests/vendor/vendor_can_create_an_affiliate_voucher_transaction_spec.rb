# frozen_string_literal: true

require_relative './credentials'
RSpec.describe 'GET /api/vendor/:vendor_id/vouchers/:voucher_id/transactions', type: :request do
  include_context 'credentials'
  describe 'cash voucher issued by affiliate' do
    let(:partner) { create(:vendor) }
    let!(:voucher) do
      create(:cash_voucher, issuer: partner.system_user, affiliate_network: true, pass_kit_id: 'qwerty')
    end
    let!(:affiliation) { partner.affiliates << vendor }
    let!(:transactions) do
      3.times { create(:transaction, voucher: voucher) }
    end
    before do
      post "/api/vendors/#{vendor.id}/vouchers/#{voucher.id}/transactions",
           params: { value: 300, honored_by: vendor.id },

           headers: valid_auth_headers_for_vendor_user
    end

    it {
      expect(response).to have_http_status 201
    }

    it 'is expected to include voucher with an updated collection of transactions' do
      expect(response_json['voucher']['transactions'].count).to eq 4
    end

    it 'is expected to record honoring vendor' do
      transaction = Transaction.last
      expect(transaction.honored_by).to eq vendor.id
    end


    it 'is expected to make a call to API burn points endpoint' do
      expect(a_request(:put, 'https://api.pub1.passkit.io/members/member/points/burn')
      .with(body: hash_including({ externalId: '12345', points: "300" }))).to have_been_made.once
    end
  end
end
