# frozen_string_literal: true

class Product < ApplicationRecord
  VALID_SERVICES = %w[lunch dinner].freeze
  validates :services, services: { in: VALID_SERVICES }
  has_many :items
  has_many :orders, through: :items
end
