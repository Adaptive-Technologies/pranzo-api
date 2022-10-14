# frozen_string_literal: true

require_relative './credentials'

RSpec.describe 'POST /api/vendors/:vendor_id/reports', type: :request do
  include_context 'credentials'
  let!(:servings_voucher) { create(:servings_voucher, issuer: vendor_user) }
  let!(:cash_voucher) { create(:cash_voucher, value: 250, issuer: vendor_user) }
  let!(:transactions) do
    Timecop.freeze(1.month.ago.beginning_of_month)
    create(:transaction, voucher: servings_voucher)
    create(:transaction, voucher: cash_voucher, amount: 100)
    Timecop.return
    create(:transaction, voucher: servings_voucher)
    create(:transaction, voucher: cash_voucher, amount: 50)
  end
  before do
    post "/api/vendors/#{vendor.id}/reports", params: { period: 'this_month' }, headers: valid_auth_headers_for_vendor_user
  end
  subject { response }

  it { is_expected.to have_http_status 201 }
end
