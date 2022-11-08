# frozen_string_literal: true

class Vendor < ApplicationRecord
  attr_accessor :legal_address

  has_many :users, dependent: :destroy
  has_many :addresses, dependent: :destroy
  accepts_nested_attributes_for :addresses

  has_one_attached :logotype
  has_many :vouchers, through: :users
  has_many :affiliations
  has_many :affiliates, through: :affiliations
  has_many :transactions, through: :vouchers

  validates_presence_of %i[name vat_id primary_email]
  validates_uniqueness_of :name

  validates :vat_id, valvat: true
  before_validation :valvat, if: proc { new_record? }

  after_save :create_system_user, unless: proc { users.pluck(:email).include? primary_email }
  after_update :update_system_user, if: proc {
                                          users.pluck(:email).include? primary_email && saved_change_to_attribute?(:primary_email) or saved_change_to_attribute?(:name)
                                        }

  def system_user
    User.system_user.where(vendor: self).first
  end

  def is_affiliated_with?(args)
    affiliation = Affiliation.find_by(vendor_id: args[:vendor_id], affiliate_id: id)
    affiliation ? true : false
  end

  def affiliated_vouchers
    vouchers = []
    affiliations = Affiliation.where(affiliate: self)
    affiliations.each do |aff|
      vouchers.append(aff.vendor.vouchers.where(affiliate_network: true, active: true))
    end
    vouchers.flatten
  end

  def validate_vat
    valvat
    save
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
    user = saved_change_to_attribute?(:primary_email) ? User.find_by(email: primary_email_previously_was) : User.find_by(email: primary_email)
    user.update(name: "#{name} (System User)", email: primary_email)
  end

  def valvat
    self.vat_id = Valvat::Utils.normalize(vat_id)
    data = Valvat.new(vat_id).exists?(detail: true)
    legal_name = data[:name]
  end
end
