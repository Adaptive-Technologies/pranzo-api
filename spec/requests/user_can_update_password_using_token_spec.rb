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

  describe 'with a redirect url' do
    before do
      post '/auth/password', params: { email: user.email, redirect_url: 'http://example.com/reset' }
    end
  
    it 'is expected to respond with a success message' do
      expect(response_json).to eq expected_response
    end
  
    it 'is expected to send out an email' do
      expect(email_queue).to eq 1
    end
  end

  describe 'without a rediredct url' do
    before do
      post '/auth/password', params: { email: user.email }
    end
  
    it 'is expected to respond with an error message' do
      expect(response_json).to eq missing_redirect_url_response
    end
  
    it 'is expected to NOT send out an email' do
      expect(email_queue).to eq 0
    end
  end

  describe 'stage 2' do
    let!(:token) do
      user.reset_password_token="123"
      user.save
      get '/auth/password/edit', params: { reset_password_token: user.reset_password_token, redirect_url: 'http://example.com/reset' }, headers: {lacale: 'sv'}
    end
    
    it 'does something' do
      binding.pry
      
    end
  end
end
