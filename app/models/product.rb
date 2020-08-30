# frozen_string_literal: true

class Product < ApplicationRecord
  VALID_SERVICES = %w[lunch dinner].freeze
  validates :services, services: { in: VALID_SERVICES }
  validates_url :image_url
  has_many :items
  has_many :orders, through: :items
  has_and_belongs_to_many :categories
end
