# frozen_string_literal: true

class CardGenerator < Prawn::Document
  def initialize(voucher)
    super({
      page_size: [144, 253],
      page_layout: :landscape,
      top_margin: 5,
      bottom_margin: 5,
      left_margin: 5, right_margin: 5
    })
    @voucher = voucher

    qr_code
    custom_text
    generate
  end

  def custom_text
    text 'Lunch Voucher', size: 22, style: :bold, position: :center, color: 'FFFFFF'
    move_down 10
    text @voucher.code
    move_down 10
  end

  def qr_code
    canvas do
      fill_color 'AE5C32'
      fill_rectangle [bounds.left, bounds.top], bounds.right, bounds.top
    end
    canvas do
      image @voucher.qr_code_path, scale: 0.65, position: :right, vposition: :bottom
    end
  end

  def generate
    file_name = Rails.public_path.join('card.pdf')
    render_file(file_name)
  end
end
