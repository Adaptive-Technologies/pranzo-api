# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'MyString' }
    factory :employee do
      role {:employee}
    end
    factory :consumer do
      role {:consumer}
    end
    factory :admin do
      role {:admin}
    end
  end
end
