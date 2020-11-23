# frozen_string_literal: true

class Voucher < ApplicationRecord
  attr_readonly :code
  validates_presence_of :paid, :value
  validates :transactions, length: { maximum: 10 }
  has_many :transactions, dependent: :destroy
  before_validation :generate_code, on: :create


  def generate_code
    self.code = SecureRandom.alphanumeric(5)
  end
end
