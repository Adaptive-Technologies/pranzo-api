RSpec.describe 'ONBOARDING FLOW - Integration', type: :request do
  let(:headers) { { HTTP_ACCEPT: 'application/json' } }
  let(:logotype) do
    File.read(fixture_path + '/files/logotype.txt')
  end
  it '' do
    puts 'Step 1: Creating a personal account'
    post '/auth',
         params: {
           email: 'user@mail.com',
           name: 'Kalle',
           password: 'password',
           password_confirmation: 'password'
         },
         headers: headers

    expect(response).to have_http_status :ok

    puts 'Step 2: Creating a vendor'
    user = User.last
    credentials = user.create_new_auth_token
    valid_auth_headers = headers.merge!(credentials)
    post '/api/vendors',
         params: {
           vendor: {
             name: 'The Other Restaurant',
             description: 'The best food in this shithole town....',
             primary_email: user.email,
             vat_id: 'DE259597697',
             logotype: logotype,
           }
         },
         headers: valid_auth_headers
    expect(response).to have_http_status :created

    puts 'Step 3: Making sure voucher.any? kicks in'
    expect do
      get "/api/vendors/#{user.reload.vendor.id}/vouchers",
          headers: valid_auth_headers.merge!(LNG: 'sv')
    end.not_to raise_error
  end
end
