# frozen_string_literal: true

require 'padded_box'
class CardCollection < Prawn::Document
  include PaddedBox

  PAGE_OPTIONS = {
    page_size: 'A4',
    page_layout: :portrait,
    top_margin: 38.267716535433074,
    bottom_margin: 38.267716535433074,
    left_margin: 42.51968503937008,
    right_margin: 42.51968503937008
  }.freeze
  attr_reader :path
  def initialize(vouchers)
    super(PAGE_OPTIONS)
    @vouchers = vouchers
    define_grid(columns: 2, rows: 5, column_gutter: 28.34645669291339, row_gutter: 0)
    fill_grids
    generate_file
  end

  def fill_grids
    col = 0
    row = 0
    @vouchers.each do |voucher|
      # background_color = voucher.value == 15 ? '000000' : '892B2F'
      grid(row, col).bounding_box do
        stroke do
          fill_color '892B2F'
          fill_and_stroke_rectangle [(cursor - bounds.height) - 5, cursor], (bounds.width + 5), (bounds.height + 5)
        end
        padded_box([bounds.left, bounds.top], 7, width: bounds.width, height: bounds.height) do
          logo
          custom_text(voucher)
          qr_code(voucher)
        end
        if col == 1
          row += 1
          col = 0
        else
          col += 1
        end
      end
    end
  end

  def logo
    logo = "#{Rails.root}/lib/bocado_logo_white.png"
    image logo, scale: 0.04, position: :right
  end

  def custom_text(voucher)
    move_down 37
    font 'Courier'
    text 'LUNCH VOUCHER', size: 16, style: :normal, position: :center, color: 'FFFFFF'
    move_down 3
    text "Code: #{voucher.code} Value: #{voucher.value}", size: 12, style: :normal, align: :left, color: 'FFFFFF'
    move_down 26
    text 'Please tell your waiter that you plan to use', size: 6, style: :normal, align: :left, color: 'FFFFFF'
    move_down 1
    text 'your voucher when you place your order.', size: 6, style: :normal, align: :left, color: 'FFFFFF'
    move_down 1
    text 'Activated at purchase. Valid until fully consumed!', size: 6, style: :bold, align: :left, color: 'FFFFFF'
    move_down 1
    text 'Kaserntorget 11, Göteborg - www.bocado.se', size: 6, style: :bold, align: :left, color: 'FFFFFF'
  end

  def qr_code(voucher)
    bounding_box([bounds.right - 50, bounds.bottom + 50], { width: 60, height: 60 }) do
      image voucher.white_qr_code_path, scale: 1, position: :right, vposition: :bottom
    end
  end

  def generate_file
    @path = Rails.public_path.join('card_collection.pdf')
    render_file(@path)
  end
end
