# frozen_string_literal: true

class Voucher < ApplicationRecord
  PERMITTED_SERVING_VALUES = [10, 15].freeze
  DEFAULT_SERVINGS_VALUE = 10
  PERMITTED_CASH_VALUES = [100, 250, 500, 1000].freeze # should this be handled by the model?
  attr_readonly :code
  validates_presence_of :value, :variant
  enum variant: { cash: 0, servings: 1 }
  has_many :transactions, dependent: :destroy
  has_one :owner, dependent: :destroy
  belongs_to :issuer, class_name: 'User'
  has_one :vendor, through: :issuer

  before_validation :generate_code, on: :create
  after_create :attach_qr_codes

  has_one_attached :qr_dark
  has_one_attached :qr_white
  has_one_attached :pdf_card

  def white_qr_code_path
    if Rails.env.test?
      ActiveStorage::Blob.service.path_for(qr_white.key)
    else
      ActiveStorage::Blob.service.url(qr_white.key, expires_in: 1.hour, disposition: 'inline', filename: qr_white.attachment.filename, content_type: 'image/svg
    +xml')
    end
  end

  def dark_qr_code_path
    if Rails.env.test?
      ActiveStorage::Blob.service.path_for(qr_dark.key)
    else
      ActiveStorage::Blob.service.url(qr_dark.key, expires_in: 1.hour, disposition: 'inline', filename: qr_dark.attachment.filename, content_type: 'image/svg
    +xml')
    end
  end

  def pdf_card_path
    if Rails.env.test?
      ActiveStorage::Blob.service.path_for(pdf_card.key)
    else
      ActiveStorage::Blob.service.url(pdf_card.key, expires_in: 1.hour, disposition: 'inline', filename: pdf_card.attachment.filename, content_type: 'applica
    tion/pdf')
    end
  end

  def generate_code
    self.code = SecureRandom.alphanumeric(5)
  end

  def email
    owner&.user&.email || owner.email if owner
  end

  def attach_qr_codes
    qrcode = RQRCode::QRCode.new(code)
    %w[dark white].each do |type|
      generate_qr_svg(qrcode, type)
    end
  end

  def generate_pdf_card
    file = CustomCardGenerator.new(self, true, 1, :sv)
    pdf_card.attach(io: File.open(file.path), filename: "#{code}-card.pdf")
  end

  def generate_qr_svg(qrcode, type)
    color = type == 'dark' ? '000' : 'FFF'
    svg = qrcode.as_svg(
      offset: 0,
      color: color,
      shape_rendering: 'crispEdges',
      module_size: 6,
      standalone: true
    )
    io = StringIO.new
    io.puts(svg)
    io.rewind
    eval("qr_#{type}.attach(io: io, filename: 'qr_#{type}#{code}.svg')")
  end

  def active?
    active
  end

  def activate!
    if active
      errors.add(:base, 'Voucher is already activated')
      false
    else
      update(active: true)
    end
  end
end
