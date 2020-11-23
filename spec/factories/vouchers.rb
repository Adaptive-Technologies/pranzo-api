# frozen_string_literal: true

FactoryBot.define do
  factory :voucher do
    value { 10 }
    code { SecureRandom.alphanumeric(5) }
    paid { true }
  end
end
