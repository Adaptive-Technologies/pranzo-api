# frozen_string_literal: true

require_relative './credentials'

RSpec.describe 'PUT /api/vendors/:vendor_id/vouchers/:id', type: :request do
  include_context 'credentials'
  describe 'without an owner' do
    describe 'for an inactive voucher' do
      subject { create(:voucher, active: false, issuer: vendor_user) }

      before do
        put "/api/vendors/#{vendor.id}/vouchers/#{subject.code}",
            params: { voucher: { command: 'activate' } },
            headers: valid_auth_headers_for_vendor_user
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
        put "/api/vendors/#{vendor.id}/vouchers/#{subject.code}",
            params: { voucher: { command: 'activate' } },
            headers: valid_auth_headers_for_vendor_user
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
        subject { create(:voucher, active: false, issuer: vendor_user) }

        before do
          put "/api/vendors/#{vendor.id}/vouchers/#{subject.code}",
              params: { voucher: {
                command: 'activate',
                email: 'new_user@mail.com'
              } },
              headers: valid_auth_headers_for_vendor_user
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

        it 'is expected to omit a call to API enrollemnt endpoint' do
          expect(a_request(:post, 'https://api.pub1.passkit.io/members/member')).to_not have_been_made
        end
      end
    end

    describe 'that belongs to a registered user' do
      let!(:registered_user) { create(:consumer, email: 'registered_user@mail.com') }
      describe 'for an inactive voucher' do
        subject { create(:voucher, active: false, issuer: vendor_user) }

        before do
          put "/api/vendors/#{vendor.id}/vouchers/#{subject.code}",
              params: { voucher: {
                command: 'activate',
                email: 'registered_user@mail.com'
              } },
              headers: valid_auth_headers_for_vendor_user.merge(locale: 'en')
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

  describe 'with activate digital wallet request' do
    subject { create(:voucher, active: false, issuer: vendor_user) }

    before do
      put "/api/vendors/#{vendor.id}/vouchers/#{subject.code}",
          params: { voucher: {
            command: 'activate',
            email: 'new_user@mail.com',
            activate_wallet: true
          } },
          headers: valid_auth_headers_for_vendor_user
    end

    it 'is expected to make a call to API enrollemnt endpoint' do
      expect(a_request(:post, 'https://api.pub1.passkit.io/members/member')
      .with(body: hash_including({ externalId: '12345', points: 10 }))).to have_been_made.once
    end
  end

  describe 'with create pdf version request' do
    subject { create(:voucher, active: false, issuer: vendor_user) }
    before do
      clear_emails

      put "/api/vendors/#{vendor.id}/vouchers/#{subject.code}",
          params: { voucher: {
            command: 'activate',
            email: 'new_user@mail.com',
            activate_wallet: 'true',
            activate_pdf: 'true',
            pdf_options: {
              variant: '3',
              language: 'en'
            }
          } },
          headers: valid_auth_headers_for_vendor_user
      sleep 1
      open_email 'new_user@mail.com'
    end

    it 'is expected to invoke #generate_pdf_card and attach file' do
      expect(subject.pdf_card.attached?).to eq true
    end

    it 'is expected to send email' do
      expect(email_queue).to eq 1
    end

    it 'is expected to include link to passkit' do
      expect(current_email).to have_link href: "https://pub1.pskt.io/#{Voucher.last.pass_kit_id}"
    end
  end
end
