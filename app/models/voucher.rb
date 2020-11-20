# frozen_string_literal: true

class Voucher < ApplicationRecord
  attr_readonly :code
  validates_presence_of :code, :paid, :value
  validates :transactions, length: { maximum: 10 }
  has_many :transactions, dependent: :destroy
end
