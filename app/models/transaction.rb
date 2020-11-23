# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :voucher
  validate :is_voucher_value_reached?

  def is_voucher_value_reached?
    if voucher && voucher.transactions.count >= voucher.value
      errors.add(:voucher, :limit_exceeded)
      voucher.errors.add(:base, :limit_exceeded)
    end
  end
end
