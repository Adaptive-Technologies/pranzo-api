# frozen_string_literal: true

FactoryBot.define do
  factory :voucher do
    value { 10 }
    code { SecureRandom.alphanumeric(5) }
    active { false }
    issuer factory: :user
    factory :servings_voucher do
      variant { :servings }
    end
    factory :cash_voucher do
      variant { :cash }
    end
  end
end
