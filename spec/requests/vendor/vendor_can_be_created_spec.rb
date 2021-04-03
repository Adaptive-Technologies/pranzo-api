# frozen_string_literal: true

RSpec.describe 'POST /api/vendors', type: :request do
  let!(:existing_user) { create(:user, email: 'existing_user@mail.com') }
  describe 'with valid attributes and address' do
    before do
      post '/api/vendors',
           params: {
             vendor: {
               name: 'The Restaurant',
               description: 'The best food in this shithole town....',
               primary_email: 'the_restaurant@mail.com',
               addresses_attributes: [{
                 street: 'High Street 190',
                 post_code: '90900',
                 city: 'Lucasville',
                 country: 'USA'
               }, {
                 street: 'Low Street 190',
                 post_code: '80000',
                 city: 'York',
                 country: 'USA'
               }]
             },
             user: {
               name: 'Karl Andersson',
               email: 'karl@mail.com',
               password: 'password',
               password_confirmation: 'password'
             }
           },
           headers: {}
    end

    it {
      expect(response).to have_http_status 201
    }

    it 'is expected to respond with representation of the new resource' do
      expect(response_json['vendor']['users'].count).to eq 2
    end

    it 'is expected to have associaited users' do
      expect(Vendor.last.users.count).to eq 2
    end

    it 'is expected to save vendor in database' do
      expect(Vendor.last.name).to eq 'The Restaurant'
    end

    it 'is expected to save vendor address in database' do
      expect(Vendor.last.addresses.first.street).to eq 'High Street 190'
    end

    it 'is expected to save all vendor addresses in database' do
      expect(Vendor.last.addresses.count).to eq 2
    end
  end

  describe 'without valid vendor attributes' do
    before do
      post '/api/vendors',
           params: {
             vendor: {
               name: 'The Restaurant'
             }
           },
           headers: {}
    end

    it {
      expect(response).to have_http_status 422
    }

    it 'responds with error message' do
      expect(response_json)
        .to have_key('message')
        .and have_value("Description can't be blank and Primary email can't be blank")
    end
  end

  describe 'without valid user attributes' do
    before do
      post '/api/vendors',
           params: {
             vendor: {
               name: 'The Restaurant',
               description: 'The best food in this shithole town....',
               primary_email: 'the_restaurant@mail.com',
             },
             user: {
              name: 'Exicting User',
              email: 'existing_user@mail.com',
              password: 'password',
              password_confirmation: 'password'
            }
           },
           headers: {}
    end

    it {
      expect(response).to have_http_status 422
    }

    it 'responds with error message' do
      expect(response_json)
        .to have_key('message')
        .and have_value("Email has already been taken")
    end
  end
end
