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

  validates_presence_of :name, :vat_id, :primary_email
  validates_uniqueness_of :name

  after_save :create_or_update_system_user
  after_update :create_or_update_system_user, if: -> { primary_email_changed? }

  def system_user
    users.find_by(role: 'system_user')
  end

  def is_affiliated_with?(args)
    Affiliation.exists?(vendor_id: args[:vendor_id], affiliate_id: id)
  end

  def affiliated_vouchers
    Voucher.joins(issuer: { vendor: :affiliations })
           .where(
             affiliations: { affiliate_id: id },
             affiliate_network: true,
             active: true
           )
           .distinct
  end

  def logotype_path
    if Rails.env.test?
      ActiveStorage::Blob.service.path_for(logotype.key)
    else
      ActiveStorage::Blob.service.url(logotype.key, expires_in: 1.hour, disposition: 'inline', filename: logotype.filename.to_s, content_type: 'image/png')
    end
  end

  private

  def create_or_update_system_user
    existing_user = User.find_by email: primary_email
    return if existing_user
    system_user = users.find_or_initialize_by(email: primary_email, role: 'system_user')
    system_user.assign_attributes(
      name: "#{name} (System User)",
      role: 'system_user',
      vendor: self
    )
    system_user.password = SecureRandom.hex(10) if system_user.new_record?
    system_user.save!(validate: false)
  end
end
