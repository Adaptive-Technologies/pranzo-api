# frozen_string_literal: true

require_relative '../credentials.rb'

RSpec.describe 'POST /admin/vouchers', type: :request do
  include_context 'credentials'
  describe 'with valid data' do
    before do
      post '/admin/vouchers',
           params: { voucher: { value: 10 } },
           headers: valid_auth_headers_for_admin
    end

    it {
      expect(response).to have_http_status 201
    }
  end

  describe 'with invalid data' do
    before do
      post '/admin/vouchers',
           params: { voucher: { value: nil } },
           headers: valid_auth_headers_for_admin
    end

    it {
      expect(response).to have_http_status 422
    }

    it 'is expected to return error message' do
      expect(response_json['message']).to eq "Value can't be blank"
    end
  end
end
