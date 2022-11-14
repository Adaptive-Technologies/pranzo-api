# frozen_string_literal: true

RSpec.describe 'POST /auth/sign_in', type: :request do
  let!(:user) { create(:user) }
  let(:user_credentials) { user.create_new_auth_token }
  let(:user_headers) do
    { HTTP_ACCEPT: 'application/json' }.merge!(user_credentials)
  end

  describe 'with valid user credentials' do
    let(:expected_response) do
      { 'status' => 'success',
        'data' => { 'email' => user.email,
                    'provider' => 'email',
                    'uid' => user.email,
                    'id' => user.id,
                    'allow_password_change' => true,
                    'name' => user.name,
                    'role' => 'consumer',
                    'created_at' => user.created_at.as_json,
                    'updated_at' => user.updated_at.as_json,
                    'vendor_id' => nil } }
    end

    before do
      put '/auth',
          params: { current_password: user.password,
                    password: 'new_password',
                    password_confirmation: 'new_password' },
          headers: user_headers
      user.reload
    end

    it 'is expected to return a 200 response status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return expected response' do
      expect(response_json).to eq expected_response
    end

    it 'is expected to update password' do
      expect(user.valid_password?('new_password')).to eq true
    end
  end

  # describe 'with invalid password' do
  #   before do
  #     post '/auth/sign_in',
  #          params: {
  #            email: user.email,
  #            password: 'wrongpassword'
  #          },
  #          headers: user_headers
  #   end

  #   it 'is expected to return a 401 response status' do
  #     expect(response).to have_http_status 401
  #   end

  #   it 'is expected to return an error message' do
  #     expect(response_json['errors']).to eq [
  #       'Invalid login credentials. Please try again.'
  #     ]
  #   end
  # end

  # describe 'with invalid email' do
  #   before do
  #     post '/auth/sign_in',
  #          params: { email: 'wrong@mail.com', password: user.password },
  #          headers: user_headers
  #   end

  #   it 'is expected to return a 401 response status' do
  #     expect(response).to have_http_status 401
  #   end

  #   it 'is expected to return an error message' do
  #     expect(response_json['errors'])
  #       .to eq [
  #         'Invalid login credentials. Please try again.'
  #       ]
  #   end
  # end
end
