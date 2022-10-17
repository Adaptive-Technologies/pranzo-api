# frozen_string_literal: true

require_relative './credentials'

RSpec.describe 'POST /api/vendors/:id/vouchers', type: :request do
  include_context 'credentials'
  describe 'BATCH creation' do
    describe 'of "servings" vouchers' do
      before do
        post "/api/vendors/#{vendor.id}/vouchers", params: {
                                                     command: 'batch',
                                                     amount: 10,
                                                     voucher: {
                                                       value: 10,
                                                       variant: 'servings'
                                                     }
                                                   },
                                                   headers: valid_auth_headers_for_vendor_user.merge(locale: 'en')
      end

      it {
        expect(response).to have_http_status 201
      }

      it 'is expected to respond with error message' do
        expect(response_json)
          .to have_key('message')
          .and have_value('10 new vouchers was created')
      end

      it 'is expected to create 10 instances of Voucher' do
        expect(Voucher.count).to eq 10
      end
    end
  end

  describe 'variant: servings' do
    describe 'with valid value' do
      Voucher::PERMITTED_SERVING_VALUES.each do |value|
        describe "of #{value} servings" do
          before do
            post "/api/vendors/#{vendor.id}/vouchers",
                 params: {
                   voucher: {
                     value: value,
                     variant: 'servings'
                   }
                 },
                 headers: valid_auth_headers_for_vendor_user
          end

          it {
            expect(response).to have_http_status 201
          }

          it 'is expected to respond with error message' do
            expect(response_json)
              .to have_key('message')
              .and have_value('Voucher was created')
          end

          it "is expected to create an instance of Voucher with value of #{value}" do
            expect(Voucher.last.value).to eq value
          end
        end
      end
    end
  end

  describe 'variant: cash' do
    describe 'with valid value' do
      Voucher::PERMITTED_CASH_VALUES.each do |value|
        describe "of #{value} servings" do
          before do
            post "/api/vendors/#{vendor.id}/vouchers",
                 params: {
                   voucher: {
                     value: value,
                     variant: 'cash'
                   }
                 },
                 headers: valid_auth_headers_for_vendor_user
          end

          it {
            expect(response).to have_http_status 201
          }

          it 'is expected to respond with error message' do
            expect(response_json)
              .to have_key('message')
              .and have_value('Voucher was created')
          end

          it "is expected to create an instance of Voucher with value of #{value}" do
            expect(Voucher.last.value).to eq value
          end
        end
      end
    end
  end

  describe 'with invalid data' do
    describe 'no value and no variant' do
      before do
        post "/api/vendors/#{vendor.id}/vouchers",
             params: {
               voucher: {
                 value: nil,
                 variant: nil
               }
             },
             headers: valid_auth_headers_for_vendor_user
      end

      it {
        expect(response).to have_http_status 422
      }

      it 'is expected to return error message' do
        expect(response_json['message']).to eq 'Value can\'t be blank and Variant can\'t be blank'
      end
    end

    describe 'invalid cash value' do
      before do
        post "/api/vendors/#{vendor.id}/vouchers",
             params: {
               voucher: {
                 value: 3000,
                 variant: 'cash'
               }
             },
             headers: valid_auth_headers_for_vendor_user
      end

      it {
        expect(response).to have_http_status 422
      }

      it 'is expected to respond with error message' do
        expect(response_json)
          .to have_key('message')
          .and have_value('You have to provide a valid value.')
      end
    end
  end
end
