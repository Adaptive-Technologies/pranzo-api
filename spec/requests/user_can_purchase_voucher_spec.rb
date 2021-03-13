# frozen_string_literal: true

RSpec.describe 'POST /api/vouchers/purchases', type: :request do
  let!(:consumer) { create(:consumer, email: 'thomas@craft.com') }
  let!(:vendor) { create(:vendor, name: 'FastFood') }
  let!(:issuer) { create(:user, vendor: vendor) }
  let(:card_token) { @stripe_test_helper.generate_card_token }

  describe 'with email param that is present in db' do
    before do
      post '/api/vouchers/purchases',
           params: {
             email: 'thomas@craft.com',
             stripe_token: card_token,
             vendor: 'FastFood',
             variant: 'servings'
           },
           headers: {}
    end
    it {
      expect(response).to have_http_status 201
    }

    it 'is expected to create an instance of Voucher' do
      expect(Voucher.last).to be_persisted
    end
  end

  describe 'with email param that is NOT present in db' do
    before do
      post '/api/vouchers/purchases',
           params: {
             email: 'another_thomas@craft.com',
             stripe_token: card_token,
             vendor: 'FastFood',
             variant: 'servings'
           },
           headers: {}
    end
    it {
      expect(response).to have_http_status 201
    }

    it 'is expected to create an instance of Voucher' do
      expect(Voucher.last).to be_persisted
    end
  end

  describe 'without valid vendor name' do
    before do
      post '/api/vouchers/purchases',
           params: {
             email: 'another_thomas@craft.com',
             stripe_token: card_token,
             vendor: 'FastFood2',
             variant: 'servings'
           },
           headers: {}
    end
    it {
      expect(response).to have_http_status 422
    }

    it 'is expected to respond with error message' do
      expect(response_json)
        .to have_key('message')
        .and have_value('You have to provide a vendor')
    end
  end

  describe 'without variant' do
    before do
      post '/api/vouchers/purchases',
           params: {
             email: 'another_thomas@craft.com',
             stripe_token: card_token,
             vendor: 'FastFood',
             variant: nil
           },
           headers: {}
    end
    it {
      expect(response).to have_http_status 422
    }

    it 'is expected to respond with error message' do
      expect(response_json)
        .to have_key('message')
        .and have_value('Variant can\'t be blank')
    end
  end
end
