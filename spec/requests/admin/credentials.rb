RSpec.shared_context 'credentials' do
  let(:admin) { create(:user, role: :admin, name: 'Thomas') }
  let(:admin_credentials) { admin.create_new_auth_token }
  let(:valid_auth_headers_for_admin) { { HTTP_ACCEPT: 'application/json' }.merge!(admin_credentials) }
end