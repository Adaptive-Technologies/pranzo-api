class Product < ApplicationRecord
  has_many :items
  has_many :orders, through: :items
  serialize :address, Array
end
