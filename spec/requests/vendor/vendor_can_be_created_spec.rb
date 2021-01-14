# frozen_string_literal: true

RSpec.describe 'POST /api/vendors', type: :request do
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
             }
           },
           headers: {}
    end

    it {
      expect(response).to have_http_status 200
    }

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

  describe 'without valid attributes' do
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
end
