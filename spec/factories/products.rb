# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { 'MyString' }
    price { 9.99 }
    services { ['lunch'] }
    image_url { 'https://picsum.photos/800' }
  end
end
