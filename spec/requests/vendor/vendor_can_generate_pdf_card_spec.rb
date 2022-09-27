require_relative './credentials'

RSpec.describe 'POST /api/vendors/:vendor_id/vouchers/:voucher_id/generate_card', type: :request do
  include_context 'credentials'
  let(:voucher) { create(:servings_voucher, issuer: vendor_user, active: true) }

  before do
    post "/api/vendors/#{vendor.id}/vouchers/#{voucher.id}/generate_card",
         headers: valid_auth_headers_for_vendor_user
  end

  subject { response }

  it { is_expected.to have_http_status :created }

  it 'is expected to include url to pdf resource' do
    binding.pry
    expect(response_json).to have_key 'url'
  end
end
