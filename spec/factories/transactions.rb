FactoryBot.define do
  factory :transaction do
    date { DateTime.now }
    voucher
  end
end
