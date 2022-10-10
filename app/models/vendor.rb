# frozen_string_literal: true

class Vendor < ApplicationRecord
  has_many :users
  has_many :addresses
  accepts_nested_attributes_for :addresses

  has_one_attached :logotype
  has_many :vouchers, through: :users
  has_many :affiliations
  has_many :affiliates, through: :affiliations

  validates_presence_of %i[name description primary_email]
  validates_uniqueness_of :name

  after_create :create_system_user
  after_update :update_system_user

  def system_user
    User.system_user.where(vendor: self).first
  end

  def is_affiliated_with?(args)
    affiliation = Affiliation.find_by(vendor_id: args[:vendor_id], affiliate_id: id)
    affiliation ? true : false
  end

  private

  def create_system_user
    system_user = User.new(
      email: primary_email,
      name: "#{name} (System User)",
      role: 'system_user',
      vendor: self
    )
    system_user.save(validate: false)
  end

  def update_system_user
    user = User.find_by(email: primary_email)
    user.update!(name: "#{name} (System User)")
  end
end
