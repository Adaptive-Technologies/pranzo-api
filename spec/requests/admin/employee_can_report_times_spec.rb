# frozen_string_literal: true

require 'rails_helper'

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
      binding.pry
      expect(response_json['timesheet']['start_date']).to eq '9:00'
    end
  end

  xdescribe 'GET /admin/timesheets' do
    it 'works! (now write some real specs)' do
      get employee_can_report_times_path
      expect(response).to have_http_status(200)
    end
  end
end
