RSpec.describe 'POST /api/validate_user', type: :request do
  subject { response }

  context 'user is NOT found ion database' do
    before do
      post '/api/validate_user', params: { uid: 'thomas@mail.com', command: "vendor" }
    end
    it { is_expected.to have_http_status 200 }

    it 'is expected to responsd with a message containing "ok"' do
      expect(response_json['message']).to eq 'ok'
    end
  end

  context 'user is found in database' do
    let!(:vendor) { create(:vendor, primary_email: 'thomas@mail.com') }
    before do
      post '/api/validate_user', params: { uid: 'thomas@mail.com' }
    end
    it 'is expected to responsd with a message containing "conflict"' do
      expect(response_json['message']).to eq 'conflict'
    end
  end
end
