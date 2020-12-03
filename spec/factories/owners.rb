FactoryBot.define do
  factory :owner do
    email { Faker::Internet.email }
    user { nil }
    voucher
    factory :owner_with_user do
      email { nil}
      user
    end
  end
end
