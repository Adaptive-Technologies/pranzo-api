# frozen_string_literal: true

require_relative '../credentials.rb'

RSpec.describe 'PUT /admin/vouchers/:id', type: :request do
  include_context 'credentials'

  describe 'for an inactive voucher' do
    subject { create(:voucher, active: false) }
    before do
      put "/admin/vouchers/#{subject.id}",
          params: { voucher: { command: 'activate' } },
          headers: valid_auth_headers_for_admin
    end

    describe 'for an inactive voucher' do
      subject { create(:voucher, active: false) }
      before do
        put "/admin/vouchers/#{subject.id}",
            params: { voucher: { command: 'activate' } },
            headers: valid_auth_headers_for_admin
      end

      it {
        expect(response).to have_http_status 201
      }

      it {
        expect(response_json)
          .to have_key('message')
          .and have_value('Voucher is now active')
      }

      it 'is expected to update the voucher to active' do
        subject.reload
        expect(subject.active?).to eq true
      end
    end

    it 'is expected to update the voucher to active' do
      subject.reload
      expect(subject.active?).to eq true
    end
  end

  describe 'for an active voucher' do
    subject { create(:voucher, active: true) }
    before do
      put "/admin/vouchers/#{subject.id}",
          params: { voucher: { command: 'activate' } },
          headers: valid_auth_headers_for_admin
    end

    it {
      expect(response).to have_http_status 422
    }

    it {
      expect(response_json)
        .to have_key('message')
        .and have_value('Voucher is already activated')
    }
  end
end
