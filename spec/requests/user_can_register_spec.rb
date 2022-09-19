# frozen_string_literal: true

RSpec.describe 'POST /auth', type: :request do
  let(:headers) { { HTTP_ACCEPT: 'application/json' } }

  describe 'with valid credentials' do
    before do
      post '/auth',
           params: {
             email: 'user@mail.com',
             name: 'Kalle',
             password: 'password',
             password_confirmation: 'password'
           },
           headers: headers
    end

    it 'is expected to return a 200 response status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return a success message' do
      expect(response_json['status']).to eq 'success'
    end
  end

  describe 'with a non-matching password confirmation' do
    before do
      post '/auth',
           params: {
             email: 'user@mail.com',
             password: 'password',
             password_confirmation: 'wrong_password'
           },
           headers: headers
    end

    it 'is expected to return a 422 response status' do
      expect(response).to have_http_status 422
    end

    it 'is expected to return an error message' do
      expect(response_json['errors']['password_confirmation'])
        .to eq ["doesn't match Password"]
    end
  end

  describe 'with an missing email address' do
    before do
      post '/auth',
           params: {
             email: '',
             password: 'password',
             password_confirmation: 'password'
           },
           headers: headers
    end

    it 'is expected to return a 422 response status' do
      expect(response).to have_http_status 422
    end

    it 'is expected to return an error message' do
      binding.pry
      expect(response_json['errors']['email'])
        .to eq ["can't be blank"]
    end
  end

  describe 'with an invalid email address' do
    before do
      post '/auth',
           params: {
             email: 'user@mail',
             password: 'password',
             password_confirmation: 'password'
           },
           headers: headers
    end

    it 'is expected to return a 422 response status' do
      expect(response).to have_http_status 422
    end

    it 'is expected to return an error message' do
      expect(response_json['errors']['email'])
        .to eq ['is not an email']
    end
  end

  describe 'with an already registered email' do
    let!(:registered_user) { create(:user, email: 'otherUser@mail.com') }

    before do
      post '/auth',
           params: {
             email: 'otherUser@mail.com',
             password: 'password',
             password_confirmation: 'password'
           },
           headers: headers
    end

    it 'is expected to return a 422 response status' do
      expect(response).to have_http_status 422
    end

    it 'is expected to return an error message' do
      expect(response_json['errors']['email']).to eq ['has already been taken']
    end
  end
end
