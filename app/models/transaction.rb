class Transaction < ApplicationRecord
  belongs_to :voucher
  # validate on: :create do
  #   if voucher && voucher.transactions.length >= 10
  #     errors.add(:voucher, :limit_exceeded)
  #   end
  # end
  validates_associated :voucher
end
