# frozen_string_literal: true

class Owner < ApplicationRecord
  belongs_to :voucher
  belongs_to :user, optional: true
  validates :email, presence: true, unless: :user
end
