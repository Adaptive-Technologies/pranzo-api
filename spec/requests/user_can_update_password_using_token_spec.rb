RSpec.describe 'POST /auth', type: :request do
  let!(:user) { create(:user, password: 'old_password') }
  let(:user_credentials) { user.create_new_auth_token }
  let(:user_headers) do
    { HTTP_ACCEPT: 'application/json' }.merge!(user_credentials)
  end
  let(:expected_response) do
    { 'success' => true,
      'message' => "An email has been sent to '#{user.email}' containing instructions for resetting your password." }
  end

  let(:missing_redirect_url_response) { { 'success' => false, 'errors' => ['Missing redirect URL.'] } }

  before do
    clear_emails
    post '/auth/password', params: { email: user.email, redirect_url: 'http://example.com/reset' }

    sleep 1
    open_email 'new_user@mail.com'
  end

  it 'is expected to respond with a success message' do
    expect(response_json).to eq expected_response
  end

  it 'is expected to send out an email' do
    expect(email_queue).to eq 1
  end
end
