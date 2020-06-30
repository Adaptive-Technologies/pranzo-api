# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /admin/timesheets' do
  let(:employee_1) { create(:user, role: :employee,  name: 'Kalle') }
  let(:employee_2) { create(:user, role: :employee,  name: 'Anders') }
  let(:admin) { create(:user, role: :admin, name: 'Thomas') }
  let(:credentials) { admin.create_new_auth_token }
  let(:valid_auth_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }

  describe 'as an :admin user' do
    let!(:time_sheets) do
      create(:time_sheet,
             date: Date.today.beginning_of_month + 15,
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

    before do
      get '/admin/timesheets',
          headers: valid_auth_headers
    end
    it 'is expected to return a collection of current timesheeets' do
      expect(response).to have_http_status(200)
    end

    it 'is expected to respond with time sheets groupes by user name' do
      expect(response_json['time_sheets'].keys.first).to eq 'Kalle'
    end

    it 'is expected to return appropoite time sheets"' do
      expect(
        response_json['time_sheets'][response_json['time_sheets'].keys.first].size
      )
        .to eq 1
    end
  end
end
