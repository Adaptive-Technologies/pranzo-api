RSpec.describe 'POST /api/vendors', type: :request do
  let(:existing_user) { create(:user, email: 'existing_user@mail.com') }
  let(:credentials) { existing_user.create_new_auth_token }
  let(:valid_auth_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
  let(:logotype) { fixture_file_upload(fixture_path + '/fast_shopping.png', 'image/png') }

  describe 'with valid attributes and address and another user' do
    before do
      post '/api/vendors',
           params: {
             vendor: {
               name: 'The Restaurant',
               description: 'The best food in this shithole town....',
               primary_email: 'the_restaurant@mail.com',
               vat_id: 'SE259597697001',
               org_id: '259597-6970', logotype:,
               addresses_attributes: [
                 {
                   street: 'High Street 190',
                   post_code: '90900',
                   city: 'Berlin',
                   country: 'Germany'
                 },
                 {
                   street: 'Low Street 190',
                   post_code: '80000',
                   city: 'York',
                   country: 'USA'
                 }
               ]
             },
             user: {
               name: 'Karl Andersson',
               email: 'karl@mail.com',
               password: 'password',
               password_confirmation: 'password'
             }
           },
           headers: valid_auth_headers
      @vendor = Vendor.last
    end

    it { expect(response).to have_http_status 201 }

    it 'is expected to attach logotype' do
      expect(@vendor.reload.logotype.attachment).to be_an_instance_of ActiveStorage::Attachment
    end

    it 'is expected to attach logotype to vendor' do
      expect(@vendor.reload.logotype.attachment.filename.to_s).to eq 'fast_shopping.png'
    end

    it 'is expected to respond with representation of the new resource' do
      expect(response_json['vendor']['users'].count).to eq 3
    end

    it 'is expected to have associated users' do
      expect(@vendor.users.count).to eq 3
    end

    it 'is expected to save vendor in database' do
      expect(@vendor.name).to eq 'The Restaurant'
    end

    it 'is expected to save vendor address in database' do
      expect(@vendor.addresses.first.street).to eq 'High Street 190'
    end

    it 'is expected to save all vendor addresses in database' do
      expect(@vendor.addresses.count).to eq 2
    end
  end

  describe 'Created by a Superadmin (TODO: this is with flaws!)' do
    let(:admin) { create(:user, role: 'admin') }
    let(:credentials) { admin.create_new_auth_token }
    let(:valid_auth_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
    before do
      post '/api/vendors',
           params: {
             vendor: {
               name: 'The Restaurant',
               description: 'The best food in this shithole town....',
               primary_email: 'the_restaurant@mail.com',
               vat_id: 'SE259597697001',
               org_id: '259597-6970',
               logotype:
             },
             user: {
               name: 'Existing User',
               email: 'existing_user@mail.com',
               password: 'password',
               password_confirmation: 'password'
             }
           },
           headers: valid_auth_headers
    end

    it { expect(response).to have_http_status 201 }

    it 'is expected to respond with representation of the new resource' do
      expect(response_json['vendor']['users'].count).to eq 2
    end

    it 'is expected to have associated users' do
      expect(Vendor.last.users.count).to eq 2
    end

    it 'is expected NOT to associate the admin with vendor' do
      expect(Vendor.last.users).not_to include admin
    end

    it 'is expected to save vendor in database' do
      expect(Vendor.last.name).to eq 'The Restaurant'
    end
  end

  describe 'without user attributes but authenticated' do
    let(:credentials) { existing_user.create_new_auth_token }
    let(:valid_auth_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
    before do
      post '/api/vendors',
           params: {
             vendor: {
               name: 'The Other Restaurant',
               description: 'The best food in this shithole town....',
               primary_email: 'the_restaurant@mail.com',
               vat_id: 'SE259597697001',
               org_id: '259597-6970', logotype:
             }, user: {}
           },
           headers: valid_auth_headers
    end

    it { expect(response).to have_http_status 201 }

    it 'is expected to attach logotype to vendor' do
      vendor = Vendor.last
      expect(vendor.logotype.attachment.filename.to_s).to eq 'fast_shopping.png'
    end

    it 'is expected to respond with representation of the new resource' do
      expect(response_json['vendor']['users'].count).to eq 2
    end

    it 'is expected to have associated users' do
      expect(Vendor.last.users.count).to eq 2
    end

    it 'is expected to save vendor in database' do
      expect(Vendor.last.name).to eq 'The Other Restaurant'
    end
  end

  describe 'with primary_email same as user.email' do
    let(:credentials) { existing_user.create_new_auth_token }
    let(:valid_auth_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
    before do
      post '/api/vendors',
           params: {
             vendor: {
               name: 'The Other Restaurant',
               description: 'The best food in this shithole town....',
               primary_email: existing_user.email,
               vat_id: 'DE259597697',
               logotype:
             }, user: {}
           },
           headers: valid_auth_headers
    end

    it { expect(response).to have_http_status 201 }

    it 'is expected to respond with representation of the new resource' do
      expect(response_json['vendor']['users'].count).to eq 1
    end

    it 'is expected to have associated users' do
      expect(Vendor.last.system_user).to be nil
    end

    it 'is expected to save vendor in database' do
      expect(Vendor.last.name).to eq 'The Other Restaurant'
    end
  end
end
