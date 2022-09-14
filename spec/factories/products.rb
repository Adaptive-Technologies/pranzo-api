# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { Faker::Restaurant.name  }
    price { 9.99 }
    subtitle { Faker::Restaurant.description }
    services { ['lunch'] }
    image_url { 'https://picsum.photos/800' }
    categories { |a| [a.association(:category)] }
  end
end
