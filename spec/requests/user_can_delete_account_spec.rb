# frozen_string_literal: true

RSpec.describe 'POST /auth', type: :request do
  let!(:user) { create(:user, password: 'old_password') }
  let(:user_credentials) { user.create_new_auth_token }
  let(:user_headers) do
    { HTTP_ACCEPT: 'application/json' }.merge!(user_credentials)
  end
  let(:expected_response) do
    { 'status' => 'success', 'message' => "Account with UID '#{user.email}' has been destroyed." }
  end

  before do
    delete '/auth', headers: user_headers
  end

  it 'is expected to return a 200 response status' do
    expect(response).to have_http_status 200
  end

  it 'is expected to return expected response' do
    expect(response_json).to eq expected_response
  end

  it 'is expected to destroy the user' do
    expect { user.reload }.to raise_error ActiveRecord::RecordNotFound
  end
end
