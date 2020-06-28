# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :items, dependent: :destroy
  has_many :products, through: :items

  def total
    items.joins(:product).sum(:price)
  end
end
