FactoryBot.define do
  factory :category do
    name { Faker::Restaurant.type  }
    promo { Faker::Restaurant.description }
  end
end
