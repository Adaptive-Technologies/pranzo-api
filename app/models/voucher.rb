# frozen_string_literal: true

class Voucher < ApplicationRecord
  attr_readonly :code
  validates_presence_of :value
  validates :transactions, length: { maximum: 10 }
  has_many :transactions, dependent: :destroy
  has_one :owner, dependent: :destroy

  before_validation :generate_code, on: :create
  after_create :attach_pdf_card

  has_one_attached :qr_dark
  has_one_attached :qr_white
  has_one_attached :pdf_card

  def white_qr_code_path
    Rails.env.test? ? ActiveStorage::Blob.service.path_for(qr_white.key) : qr_white.service_url(expires_in: 1.hour, disposition: 'inline')
  end

  def dark_qr_code_path
    Rails.env.test? ? ActiveStorage::Blob.service.path_for(qr_dark.key) : qr_dark.service_url(expires_in: 1.hour, disposition: 'inline')
  end

  def pdf_card_path
    Rails.env.test? ? ActiveStorage::Blob.service.path_for(pdf_card.key) : pdf_card.service_url(expires_in: 1.hour, disposition: 'inline')
  end

  def generate_code
    self.code = SecureRandom.alphanumeric(5)
  end

  def email
    owner&.user&.email || owner.email if owner
  end

  def attach_pdf_card
    qrcode = RQRCode::QRCode.new(code)
    %w[dark white].each do |type|
      generate_qr_png(qrcode, type)
    end
  end

  def generate_qr_png(qrcode, type)
    # color = type == 'dark' ? 'black' : 'white'
    # png = qrcode.as_png(
    #   bit_depth: 1,
    #   border_modules: 4,
    #   color_mode: ChunkyPNG::COLOR_GRAYSCALE,
    #   color: color,
    #   file: nil,
    #   fill: ChunkyPNG::Color::TRANSPARENT,
    #   module_px_size: 6,
    #   resize_exactly_to: false,
    #   resize_gte_to: false,
    #   size: 60
    # )
    color = type == 'dark' ? '000' : 'FFF'
    svg = qrcode.as_svg(
      offset: 0,
      color: color,
      shape_rendering: 'crispEdges',
      module_size: 6,
      standalone: true
    )
    io = StringIO.new
    # io.puts(png.to_s)
    io.puts(svg)
    io.rewind
    # eval("qr_#{type}.attach(io: io, filename: 'qr_#{type}#{code}.png')")
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
