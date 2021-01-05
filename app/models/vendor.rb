class Vendor < ApplicationRecord
  has_many :users
  has_many :addresses

  has_one_attached :logotype
end
