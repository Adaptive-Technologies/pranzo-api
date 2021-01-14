# frozen_string_literal: true

class Vendor < ApplicationRecord
  has_many :users
  has_many :addresses
  accepts_nested_attributes_for :addresses

  has_one_attached :logotype

  validates_presence_of %i[name description primary_email]

  after_create :create_system_user

  def system_user
    User.system_user.where(vendor: self).first
  end

  private

  def create_system_user
    system_user = User.new(
      email: primary_email,
      name: 'System User',
      role: 'system_user',
      vendor: self
    )
    system_user.save(validate: false)
  end
end
