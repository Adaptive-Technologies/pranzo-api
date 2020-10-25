# frozen_string_literal: true
require_relative './credentials.rb'

RSpec.describe 'GET /admin/users', type: :request do
  let!(:employees) { 5.times { create(:employee) } }
  let!(:admins) { 2.times { create(:admin) } }
  let!(:consumers) { 5.times { create(:consumer) } }
  include_context 'credentials'

  describe 'without a list type' do
    before do
      get '/admin/users',
          params: {},
          headers: valid_auth_headers_for_admin
    end

    it {
      expect(response).to have_http_status 400
    }

    it 'is expected to return an error message' do
      expect(response_json['message']).to eq 'Error: Please specify list type'
    end
  end

  describe 'with list type specified' do
    before do
      get '/admin/users',
          params: { type: 'short_list' },
          headers: valid_auth_headers_for_admin
    end

    it {
      expect(response).to have_http_status 200
    }

    it 'is expected to return a collection of employees' do
      expect(response_json['users'].size).to eq 5
    end
  end
end
