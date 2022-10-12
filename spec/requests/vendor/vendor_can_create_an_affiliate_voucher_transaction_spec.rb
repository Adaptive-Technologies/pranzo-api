# frozen_string_literal: true

require_relative './credentials'
RSpec.describe 'GET /api/vendor/:vendor_id/vouchers/:voucher_id/transactions', type: :request do
  include_context 'credentials'
  let(:partner) { create(:vendor) }
  let!(:voucher) do
    create(:cash_voucher, issuer: partner.system_user, value: 1000, affiliate_network: true, pass_kit_id: 'qwerty')
  end
  let!(:affiliation) { partner.affiliates << vendor }
  let!(:transactions) do
    3.times { create(:transaction, voucher: voucher, amount: 100) }
  end
  describe 'cash voucher issued by affiliate' do
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

  describe 'emptying down to zero' do
    before do
      post "/api/vendors/#{vendor.id}/vouchers/#{voucher.id}/transactions",
           params: { value: 700, honored_by: vendor.id },

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

    it 'is expected to set voucher.current_value to 0' do
      voucher.reload
      expect(voucher.current_value).to eq 0
    end


    it 'is expected to make a call to API burn points endpoint' do
      expect(a_request(:put, 'https://api.pub1.passkit.io/members/member/points/burn')
      .with(body: hash_including({ externalId: '12345', points: "700" }))).to have_been_made.once
    end
  end


  describe 'request contains to larger value than current_value' do
    before do
      post "/api/vendors/#{vendor.id}/vouchers/#{voucher.id}/transactions",
           params: { value: 3000, honored_by: vendor.id },

           headers: valid_auth_headers_for_vendor_user
    end

    it {
      expect(response).to have_http_status 200
    }

    it 'is expected to include voucher data' do
      expect(response_json['voucher']['transactions'].count).to eq 3
    end

    it 'is expected to include message' do
      expect(response_json['message']).to eq "The requested amount exceeds available balance"
    end

    it 'is NOT expected to make a call to API burn points endpoint' do
      expect(a_request(:put, 'https://api.pub1.passkit.io/members/member/points/burn')).not_to have_been_made.once
    end
  end

 
end
