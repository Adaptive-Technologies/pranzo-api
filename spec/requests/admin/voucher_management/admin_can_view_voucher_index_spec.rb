# frozen_string_literal: true

require_relative '../credentials.rb'
RSpec.describe 'GET /admin/vouchers', type: :request do
  include_context 'credentials'
  let!(:vouchers) { 5.times { create(:voucher) } }
  let!(:transactions) do
    vouchers_collection = Voucher.all
    create(:transaction, voucher: vouchers_collection[0])
    create(:transaction, voucher: vouchers_collection[0])
    create(:transaction, voucher: vouchers_collection[1])
    create(:transaction, voucher: vouchers_collection[1])
  end
  describe 'when logged authenticated as admin' do
    before do
      get '/admin/vouchers',
          headers: valid_auth_headers_for_admin
    end

    it {
      expect(response).to have_http_status 200
    }

    it 'is expected to include collection of vouchers' do
      expect(response_json['vouchers'].count).to eq 5
    end
  end
end
