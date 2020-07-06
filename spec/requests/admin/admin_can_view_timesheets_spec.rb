# frozen_string_literal: true

RSpec.describe 'GET /admin/timesheets' do
  let(:employee_1) { create(:user, role: :employee,  name: 'Kalle') }
  let(:employee_2) { create(:user, role: :employee,  name: 'Anders') }
  let(:admin) { create(:user, role: :admin, name: 'Thomas') }
  let(:admin_credentials) { admin.create_new_auth_token }
  let(:valid_auth_headers_for_admin) { { HTTP_ACCEPT: 'application/json' }.merge!(admin_credentials) }
  let(:employee_credentials) { employee_1.create_new_auth_token }
  let(:valid_auth_headers_for_employee) { { HTTP_ACCEPT: 'application/json' }.merge!(employee_credentials) }

  let!(:time_sheets) do
    create(:time_sheet,
           date: Date.today.beginning_of_month + 15,
           user: employee_1,
           start_time: '09:00',
           end_time: '15:00')

    create(:time_sheet,
           date: Date.today.beginning_of_month + 16,
           user: employee_1,
           start_time: '09:00',
           end_time: '15:00')

    create(:time_sheet,
           date: Date.today.months_ago(1).beginning_of_month + 10,
           user: employee_1,
           start_time: '09:00',
           end_time: '15:00')

    create(:time_sheet,
           date: Date.today.beginning_of_month + 15,
           user: employee_2,
           start_time: '09:00',
           end_time: '15:00')

    create(:time_sheet,
           date: Date.today.months_ago(1).beginning_of_month + 10,
           user: employee_2,
           start_time: '09:00',
           end_time: '15:00')
  end
  describe 'as an :admin user' do
    before do
      get '/admin/timesheets',
          headers: valid_auth_headers_for_admin
    end
    it 'is expected to return a collection of current timesheeets' do
      expect(response).to have_http_status(200)
    end

    it 'is expected to respond with time sheets groupes by user name' do
      expect(response_json['users'].keys.first).to eq 'Kalle'
    end

    it 'is expected to return appropoite "time sheets"' do
      expect(
        response_json['users'][response_json['users'].keys.first]['time_sheets'].size
      )
        .to eq 2
    end

    it 'is expected to return appropoite "total_hours"' do
      expect(
        response_json['users'][response_json['users'].keys.first]['total_hours']
      )
        .to eq '12.0'
    end
  end

  describe 'as an employee' do
    before do
      get '/admin/timesheets',
          headers: valid_auth_headers_for_employee
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