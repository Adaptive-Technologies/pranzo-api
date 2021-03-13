# frozen_string_literal: true

RSpec.describe 'POST /api/vouchers/purchases', type: :request do
  let!(:consumer) { create(:consumer, email: 'thomas@craft.com') }
  let!(:vendor) { create(:vendor, name: 'FastFood') }
  let!(:issuer) { create(:user, vendor: vendor) }
  let(:card_token) { @stripe_test_helper.generate_card_token }

  describe 'variant: servings' do
    describe 'with default value (10)' do
      before do
        post '/api/vouchers/purchases',
             params: {
               email: 'thomas@craft.com',
               stripe_token: card_token,
               vendor: 'FastFood',
               variant: 'servings'
             },
             headers: {}
      end

      it {
        expect(response).to have_http_status 201
      }

      it 'is expected to create an instance of Voucher with value 10' do
        expect(Voucher.last.value).to eq 10
      end
    end

    describe 'with value (15)' do
      before do
        post '/api/vouchers/purchases',
             params: {
               email: 'thomas@craft.com',
               stripe_token: card_token,
               vendor: 'FastFood',
               variant: 'servings',
               value: '15'
             },
             headers: {}
      end

      it {
        expect(response).to have_http_status 201
      }

      it 'is expected to create an instance of Voucher with value 15' do
        expect(Voucher.last.value).to eq 15
      end
    end

    describe 'with an invalid value' do
      before do
        post '/api/vouchers/purchases',
             params: {
               email: 'thomas@craft.com',
               stripe_token: card_token,
               vendor: 'FastFood',
               variant: 'servings',
               value: '30'
             },
             headers: {}
      end

      it {
        expect(response).to have_http_status 422
      }

      it 'is expected to respond with error message' do
        expect(response_json)
          .to have_key('message')
          .and have_value('We couldn\'t create the voucher as requested.')
      end
    end
    describe 'with email param that is present in db' do
      before do
        post '/api/vouchers/purchases',
             params: {
               email: 'thomas@craft.com',
               stripe_token: card_token,
               vendor: 'FastFood',
               variant: 'servings'
             },
             headers: {}
      end
      it {
        expect(response).to have_http_status 201
      }

      it 'is expected to create an instance of Voucher' do
        expect(Voucher.last).to be_persisted
      end

      it 'is expected to have variant :servings' do
        expect(Voucher.last.servings?).to be_truthy
      end
    end

    describe 'with email param that is NOT present in db' do
      before do
        post '/api/vouchers/purchases',
             params: {
               email: 'another_thomas@craft.com',
               stripe_token: card_token,
               vendor: 'FastFood',
               variant: 'servings'
             },
             headers: {}
      end
      it {
        expect(response).to have_http_status 201
      }

      it 'is expected to create an instance of Voucher' do
        expect(Voucher.last).to be_persisted
      end
    end

    describe 'without valid vendor name' do
      before do
        post '/api/vouchers/purchases',
             params: {
               email: 'another_thomas@craft.com',
               stripe_token: card_token,
               vendor: 'FastFood2',
               variant: 'servings'
             },
             headers: {}
      end
      it {
        expect(response).to have_http_status 422
      }

      it 'is expected to respond with error message' do
        expect(response_json)
          .to have_key('message')
          .and have_value('You have to provide a vendor')
      end
    end
  end

  describe 'variant: cash' do
    describe 'without value parameter' do
      before do
        post '/api/vouchers/purchases',
             params: {
               email: 'thomas@craft.com',
               stripe_token: card_token,
               vendor: 'FastFood',
               variant: 'cash'
             },
             headers: {}
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

    describe 'with a valid value' do

      [100, 250, 500].each do |value|
        describe "of #{value}" do
          before do
            post '/api/vouchers/purchases',
                 params: {
                   email: 'thomas@craft.com',
                   stripe_token: card_token,
                   vendor: 'FastFood',
                   variant: 'cash',
                   value: value
                 },
                 headers: {}
          end
          it {
            expect(response).to have_http_status 201
          }

          it 'is expected to create an instance of Voucher' do
            expect(Voucher.last).to be_persisted
          end

          it 'is expected to have variant :cash' do
            expect(Voucher.last.cash?).to be_truthy
          end

          it "is expected to have value: #{value}" do
            expect(Voucher.last.value).to eq value
          end
        end
      end
    end

    describe 'with an invalaid value' do
      before do
        post '/api/vouchers/purchases',
             params: {
               email: 'thomas@craft.com',
               stripe_token: card_token,
               vendor: 'FastFood',
               variant: 'cash',
               value: 30000
             },
             headers: {}
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

  describe 'without variant' do
    before do
      post '/api/vouchers/purchases',
           params: {
             email: 'another_thomas@craft.com',
             stripe_token: card_token,
             vendor: 'FastFood',
             variant: nil
           },
           headers: {}
    end
    it {
      expect(response).to have_http_status 422
    }

    it 'is expected to respond with error message' do
      expect(response_json)
        .to have_key('message')
        .and have_value('Variant can\'t be blank')
    end
  end
end
