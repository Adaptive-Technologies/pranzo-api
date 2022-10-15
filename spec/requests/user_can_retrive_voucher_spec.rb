# frozen_string_literal: true

RSpec.describe 'GET /api/vouchers/:code', type: :request do

  describe 'with a valid code and non-registerd owner' do
    let!(:owner) { create(:owner, voucher: voucher, email: 'thomas@craft.com') }
    let(:voucher) { create(:voucher) }
    let!(:transactions) { 3.times { create(:transaction, voucher: voucher) } }
    before do
      get "/api/vouchers/#{voucher.code}"
    end

    it {
      expect(response).to have_http_status 200
    }

    it 'is expected to return voucher details' do
      expect(response_json['voucher'].keys)
        .to match %w[id code active value variant current_value email affiliate_network transactions]
    end

    it {
      expect(JSON.parse(response.body, { symbolize_names: true })[:voucher])
        .to have_key(:email).and have_value('thomas@craft.com')
    }

    it {
      expect(JSON.parse(response.body, { symbolize_names: true })[:voucher])
        .to have_key(:code).and have_value('12345')
    }

    it {
      expect(JSON.parse(response.body, { symbolize_names: true })[:voucher])
        .to have_key(:value).and have_value(10)
    }
  end

  describe 'with a valid code and registerd owner' do
    let!(:owner) { create(:owner, voucher: voucher, user: create(:consumer, email: 'consumer@mail.com')) }
    let(:voucher) { create(:voucher, value: 15) }
    let!(:transactions) { 3.times { create(:transaction, voucher: voucher) } }
    before do
      get "/api/vouchers/#{voucher.code}"
    end

    it {
      expect(response).to have_http_status 200
    }

    it 'is expected to return voucher details' do
      expect(response_json['voucher'].keys)
        .to match %w[id code active value variant current_value email affiliate_network transactions]
    end

    it {
      expect(response_json['voucher'])
        .to have_key('email').and have_value('consumer@mail.com')
    }

    it {
      expect(response_json['voucher'])
        .to have_key('code').and have_value('12345')
    }

    it {
      expect(JSON.parse(response.body)['voucher'])
        .to have_key('value').and have_value(15)
    }
  end

  describe 'with an invalid code' do
    before do
      get '/api/vouchers/xxxxx'
    end

    it {
      expect(response).to have_http_status 404
    }

    it 'is expected to return an error message' do
      expect(response_json['message'])
        .to eq 'The voucher code is invalid, try again.'
    end
  end
end
