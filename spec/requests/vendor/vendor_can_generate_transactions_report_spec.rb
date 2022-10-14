# frozen_string_literal: true

require_relative './credentials'

RSpec.describe 'POST /api/vendors/:vendor_id/reports', type: :request do
  include_context 'credentials'
  let!(:servings_voucher) { create(:servings_voucher, value: 15, issuer: vendor_user) }
  let!(:servings_voucher_2) { create(:servings_voucher, value: 15, issuer: vendor_user) }
  let!(:servings_voucher_3) { create(:servings_voucher, value: 15, issuer: vendor_user) }
  let!(:cash_voucher) { create(:cash_voucher, value: 1000, issuer: vendor_user) }
  let!(:transactions) do
    Timecop.freeze(1.week.ago.beginning_of_week)
    create(:transaction, voucher: servings_voucher_3)
    create(:transaction, voucher: cash_voucher, amount: 100)
    create(:transaction, voucher: cash_voucher, amount: 150)
    Timecop.return
    Timecop.freeze(1.week.ago.beginning_of_week + 1.day)
    create(:transaction, voucher: servings_voucher_2)
    Timecop.return
    Timecop.freeze(1.week.ago.beginning_of_week + 3.day)
    create(:transaction, voucher: servings_voucher_2)
    Timecop.return
    Timecop.freeze(1.week.ago.beginning_of_week + 5.day)
    create(:transaction, voucher: servings_voucher_2)
    create(:transaction, voucher: cash_voucher, amount: 100)
    Timecop.return
    Timecop.freeze(3.day.ago)
    create(:transaction, voucher: servings_voucher_3)
    create(:transaction, voucher: servings_voucher_2)
    create(:transaction, voucher: servings_voucher)
    create(:transaction, voucher: servings_voucher_2)
    create(:transaction, voucher: servings_voucher)
    Timecop.return
    Timecop.freeze(2.day.ago)
    create(:transaction, voucher: servings_voucher_3)
    create(:transaction, voucher: servings_voucher_2)
    create(:transaction, voucher: servings_voucher)
    create(:transaction, voucher: servings_voucher_2)
    create(:transaction, voucher: servings_voucher)
    Timecop.return
    Timecop.freeze(1.day.ago)
    create(:transaction, voucher: servings_voucher_3)
    create(:transaction, voucher: servings_voucher_2)
    create(:transaction, voucher: servings_voucher_2)
    create(:transaction, voucher: servings_voucher_2)
    create(:transaction, voucher: servings_voucher_3)
    create(:transaction, voucher: servings_voucher)
    create(:transaction, voucher: servings_voucher_2)
    create(:transaction, voucher: cash_voucher, amount: 75)
    Timecop.return
    create(:transaction, voucher: servings_voucher_3)
    create(:transaction, voucher: servings_voucher)
    create(:transaction, voucher: cash_voucher, amount: 50)
  end
  before do
    post "/api/vendors/#{vendor.id}/reports", params: { period: 'this_month' }, headers: valid_auth_headers_for_vendor_user
  end
  subject { response }

  it { is_expected.to have_http_status 201 }
end
