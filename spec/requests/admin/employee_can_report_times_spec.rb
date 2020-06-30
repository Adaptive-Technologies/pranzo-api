# frozen_string_literal: true

RSpec.describe '/admin/timesheets', type: :request do
  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:valid_auth_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }

  describe 'POST /admin/timesheets' do
    before do
      post '/admin/timesheets',
           params: {
             timesheet:
             { date: '2020-01-05', start_time: '09:00', end_time: '15:00' }
           },
           headers: valid_auth_headers
    end
    it {
      expect(response).to have_http_status 201
    }

    it 'is expected to return the start_time' do
      expect(response_json['timesheet']['start_time']).to eq '09:00'
    end

    it 'is expected to return the end_time' do
      expect(response_json['timesheet']['end_time']).to eq '15:00'
    end

    it 'is expected to return the duration' do
      expect(response_json['timesheet']['duration']).to eq '6.0'
    end
  end

  describe 'GET /admin/timesheets' do
    describe 'as a user' do
      let!(:user_time_sheets) do
        create(:time_sheet, date: Date.today.beginning_of_month + 15, user: user, start_time: '09:00', end_time: '15:00')
        create(:time_sheet, date: Date.today.months_ago(1).beginning_of_month + 10, user: user, start_time: '09:00', end_time: '15:00')
        create(:time_sheet, date: Date.today.beginning_of_month + 16, user: user, start_time: '09:00', end_time: '15:00')
        create(:time_sheet, date: Date.today.months_ago(1).beginning_of_month + 11, user: user, start_time: '09:00', end_time: '15:00')

      end
      let!(:another_user_time_sheets) do
        create(:time_sheet, date: Date.today)
        create(:time_sheet, date: 1.month.ago)
      end
      before do
        get '/admin/timesheets',
            headers: valid_auth_headers
      end
      it 'is expected to return a collection of current timesheeets' do
        expect(response).to have_http_status(200)
      end

      it 'is expected to respond with time sheets filtered by user' do
        expect(response_json['time_sheets'].size).to eq 2
      end

      it 'is expected to calculate "total hours"' do
        expect(response_json['total_hours']).to eq '12.0'
      end
    end
  end
end
