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
    expect(response_json).to have_key 'url'
  end

  describe 'card content' do
    let(:pdf) do
      file = File.open(Voucher.last.pdf_card_path)
      PDF::Inspector::Text.analyze_file(file)
    end
    
    it 'is expected to have content based on voucher data' do
      expect(pdf.strings)
        .to include('KLIPPKORT')
        .and include('Kod: 12345')
        .and include('VÄRDE 10')
    end
  end
end
