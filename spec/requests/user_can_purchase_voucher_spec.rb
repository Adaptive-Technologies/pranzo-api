# frozen_string_literal: true

RSpec.describe 'POST /api/vouchers/purchases', type: :request do
  let!(:consumer) { create(:consumer, email: 'thomas@craft.com') }
  let!(:vendor) { create(:vendor) }
  let!(:issuer) { create(:user, vendor: vendor) }
  let(:card_token) { @stripe_test_helper.generate_card_token }

  describe 'with email param that is present in db' do
    before do
      post '/api/vouchers/purchases',
           params: { email: 'thomas@craft.com', stripe_token: card_token, vendor_id: 1 },
           headers: {}
    end
    it {
      expect(response).to have_http_status 201
    }

    it 'is expected to create an instance of Order' do
      expect(Voucher.last).to be_persisted
    end
  end

  describe 'with email param that is NOT present in db' do
    before do
      post '/api/vouchers/purchases',
           params: { email: 'another_thomas@craft.com', stripe_token: card_token },
           headers: {}
    end
    it {
      expect(response).to have_http_status 201
    }

    it 'is expected to create an instance of Order' do
      expect(Voucher.last).to be_persisted
    end
  end
end
