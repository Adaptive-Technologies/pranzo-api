# frozen_string_literal: true

class Voucher < ApplicationRecord
  attr_readonly :code
  validates_presence_of :paid, :value
  validates :transactions, length: { maximum: 10 }
  has_many :transactions, dependent: :destroy
  before_validation :generate_code, on: :create
  after_create :generate_qr_code
  has_one_attached :qr

  def qr_code_path
    ActiveStorage::Blob.service.path_for(v.qr.key)
  end

  def generate_code
    self.code = SecureRandom.alphanumeric(5)
  end

  def generate_qr_code
    qrcode = RQRCode::QRCode.new(code)
    png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: 'black',
      file: nil,
      fill: 'white',
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 120
    )
    io = StringIO.new
    io.puts(png.to_s)
    io.rewind
    qr.attach(io: io, filename: "qr_#{code}.png")
  end
end
