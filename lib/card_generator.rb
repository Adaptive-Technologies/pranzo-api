# frozen_string_literal: true

class CardGenerator < Prawn::Document
  attr_reader :path
  def initialize(voucher)
    super({
      page_size: [144, 253],
      page_layout: :landscape,
      top_margin: 5,
      bottom_margin: 5,
      left_margin: 10, right_margin: 10
    })
    @voucher = voucher
    @path = nil
    background
    logo
    custom_text
    qr_code
    generate_file
  end

  def background
    canvas do
      fill_color '892B2F'
      fill_rectangle [bounds.left, bounds.top], bounds.right, bounds.top
    end
  end

  def logo
    move_down 5
    logo = "#{Rails.root}/lib/bocado_logo_white.png"
    image logo, scale: 0.05, position: :right
  end

  def custom_text
    move_down 35
    font 'Courier'
    text 'LUNCH VOUCHER', size: 16, style: :normal, position: :center, color: 'FFFFFF'
    move_down 16
    text "Code: #{@voucher.code} Value: #{@voucher.value}", size: 12, style: :normal, position: :center, color: 'FFFFFF'
    move_down 2
    text 'Please tell your waiter that you plan to use', size: 6, style: :normal, position: :center, color: 'FFFFFF'
    move_down 1
    text 'your voucher when you place your order.', size: 6, style: :normal, position: :center, color: 'FFFFFF'
    move_down 4
    text "Purchased: #{@voucher.created_at.strftime('%B %Y')} Valid until fully consumed!", size: 6, style: :bold, position: :center, color: 'FFFFFF'
  end

  def qr_code
    canvas do
      image @voucher.white_qr_code_path, scale: 0.9, position: :right, vposition: :bottom
    end
  end

  def generate_file
    @path = Rails.public_path.join('card.pdf')
    render_file(@path)
  end
end
