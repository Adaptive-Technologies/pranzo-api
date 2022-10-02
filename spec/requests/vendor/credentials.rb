RSpec.shared_context 'credentials' do
  let(:vendor) { create(:vendor, name: "The Other Place")}
  let(:vendor_user) { create(:user, role: :vendor, name: 'Thomas', vendor: vendor) }
  let(:vendor_user_credentials) { vendor_user.create_new_auth_token }
  let(:valid_auth_headers_for_vendor_user) { { HTTP_ACCEPT: 'application/json' }.merge!(vendor_user_credentials) }
end