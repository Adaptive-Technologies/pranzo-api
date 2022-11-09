# frozen_string_literal: true

RSpec.describe 'PUT /api/vendors/:id', type: :request do
  let(:vendor) { create(:vendor, name: 'The Restaurant') }
  let(:user) { create(:user, email: 'existing_user@mail.com', vendor: vendor) }
  let(:credentials) { user.create_new_auth_token }
  let(:valid_auth_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
  let(:logotype) do
    File.read(fixture_path + '/files/logotype.txt')
  end
  describe '' do
    before do
      put "/api/vendors/#{vendor.id}", params: {
        vendor: {
          name: 'The New Restaurant',
          logotype: logotype,
        }, headers: {}
      }
    end

    it {
      expect(response).to have_http_status 200
    }

    it 'is expected to attach logotype' do
      expect(vendor.reload.logotype.attachment).to be_an_instance_of ActiveStorage::Attachment
    end

    it 'is expected to return vendor object' do
      expect(response_json['vendor'])
        .to have_key('name')
        .and have_value('The New Restaurant')
    end

    it 'is expected to rename the System User' do
      system_user = User.find_by(email: vendor.primary_email)
      expect(system_user.name).to eq 'The New Restaurant (System User)'
    end
  end
end
