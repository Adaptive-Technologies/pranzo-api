# frozen_string_literal: true

RSpec.describe 'POST /auth', type: :request do
  let!(:user) { create(:user, password: 'old_password') }
  let(:user_credentials) { user.create_new_auth_token }
  let(:user_headers) do
    { HTTP_ACCEPT: 'application/json' }.merge!(user_credentials)
  end

  describe '::password change' do
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

    describe 'without current password' do
      let(:expected_response) do
        { 'status' => 'error',
          'errors' => { 'current_password' => ["can't be blank"],
                        'full_messages' => ["Current password can't be blank"] } }
      end
      before do
        put '/auth',
            params: { current_password: '',
                      password: 'new_password',
                      password_confirmation: 'new_password' },
            headers: user_headers
        user.reload
      end

      it 'is expected to return a 422 response status' do
        expect(response).to have_http_status 422
      end

      it 'is expected to return expected response' do
        expect(response_json).to eq expected_response
      end

      it 'is expected to keep password' do
        expect(user.valid_password?('old_password')).to eq true
      end
    end

    describe 'with wrong current password' do
      let(:expected_response) do
        { 'status' => 'error',
          'errors' => { 'current_password' => ['is invalid'], 'full_messages' => ['Current password is invalid'] } }
      end
      before do
        put '/auth',
            params: { current_password: 'wrong_password',
                      password: 'new_password',
                      password_confirmation: 'new_password' },
            headers: user_headers
        user.reload
      end

      it 'is expected to return a 422 response status' do
        expect(response).to have_http_status 422
      end

      it 'is expected to return expected response' do
        expect(response_json).to eq expected_response
      end

      it 'is expected to keep password' do
        expect(user.valid_password?('old_password')).to eq true
      end
    end

    describe 'with wrong current password' do
      let(:expected_response) do
        { 'status' => 'error',
          'errors' => { 'password_confirmation' => ["doesn't match Password"],
                        'full_messages' => ["Password confirmation doesn't match Password"] } }
      end
      before do
        put '/auth',
            params: { current_password: 'old_password',
                      password: 'new_password',
                      password_confirmation: 'wrong_new_password' },
            headers: user_headers
        user.reload
      end

      it 'is expected to return a 422 response status' do
        expect(response).to have_http_status 422
      end

      it 'is expected to return expected response' do
        expect(response_json).to eq expected_response
      end

      it 'is expected to keep password' do
        expect(user.valid_password?('old_password')).to eq true
      end
    end
  end
end
