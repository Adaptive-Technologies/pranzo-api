# frozen_string_literal: true

require_relative './credentials'

RSpec.describe 'POST /api/vendors/:vendor_id/reports', type: :request do
  let!(:servings_voucher) { create(:servings_voucher, issuer: vendor_user) }
  let!(:cash_voucher) { create(:servings_voucher, issuer: vendor_user) }
  let!(:old_transactions) do
    
  end
  include_context 'credentials'
  before do
    post "/api/vendors/#{vendor.id}/reports", headers: valid_auth_headers_for_vendor_user
  end
  subject { response }

  it { is_expected.to have_http_status 201 }
end
