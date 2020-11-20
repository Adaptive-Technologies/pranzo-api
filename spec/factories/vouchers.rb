# frozen_string_literal: true

FactoryBot.define do
  factory :voucher do
    value { 10 }
    code { 'QQQQQ' }
    paid { true }
  end
end
