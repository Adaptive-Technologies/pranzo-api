# frozen_string_literal: true

require_relative '../credentials.rb'

RSpec.describe 'PUT /admin/vouchers/:id', type: :request do
  include_context 'credentials'

  describe 'without an owner' do
    describe 'for an inactive voucher' do
      subject { create(:voucher, active: false) }
      before do
        put "/admin/vouchers/#{subject.code}",
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

    describe 'for an active voucher' do
      subject { create(:voucher, active: true) }
      before do
        put "/admin/vouchers/#{subject.code}",
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

  describe 'with an email' do
    describe 'that is not registered for a user' do
      describe 'for an inactive voucher' do
        subject { create(:voucher, active: false) }
        before do
          put "/admin/vouchers/#{subject.code}",
              params: { voucher: {
                command: 'activate',
                email: 'new_user@mail.com'
              } },
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

        it 'is expected to set an owner' do
          subject.reload
          expect(subject.owner.email).to eq 'new_user@mail.com'
        end
      end
    end

    describe 'that belongs to a registered user' do
      let!(:registered_user) { create(:consumer, email: 'registered_user@mail.com')}
      describe 'for an inactive voucher' do
        subject { create(:voucher, active: false) }
        before do
          put "/admin/vouchers/#{subject.code}",
              params: { voucher: {
                command: 'activate',
                email: 'registered_user@mail.com'
              } },
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

        it 'is expected to set an owner' do
          subject.reload
          expect(subject.owner.email).to eq 'registered_user@mail.com'
        end

        it 'is expected to set associate voucher with registered user' do
          subject.reload
          expect(subject.owner.user).to eq registered_user
        end
      end
    end
  end
end