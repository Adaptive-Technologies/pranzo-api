# frozen_string_literal: true

require 'padded_box'
class CustomCardGenerator < Prawn::Document
  attr_reader :path
  include PaddedBox
  def initialize(voucher, render = true)
    super({
      page_size: [144, 253],
      page_layout: :landscape,
      top_margin: 0,
      bottom_margin: 5,
      left_margin: 0, right_margin: 10
    })
    @voucher = voucher
    @path = nil
    font_families.update(
      'Gotham' => { bold: "#{Rails.root}/lib/assets/fonts/Gotham-Bold.ttf",
                    normal: "#{Rails.root}/lib/assets/fonts/Gotham-Medium.ttf",
                    light: "#{Rails.root}/lib/assets/fonts/Gotham-Light.ttf" }
    )
    background
    logo
    custom_text
    qr_code
    generate_file if render
  end

  def background
    canvas do
      svg IO.read("#{Rails.root}/lib/assets/background_1.svg"), at: [bounds.left - 5, bounds.top + 5], width: bounds.width + 10, height: bounds.height + 10
      svg IO.read("#{Rails.root}/lib/assets/tone_1.svg"), vposition: :top
      svg IO.read("#{Rails.root}/lib/assets/text_area_1.svg"), vposition: :bottom
      svg IO.read("#{Rails.root}/lib/assets/pranzo_symbol.svg"), at: [bounds.left + 10, bounds.top - 13], width: 15
      font 'Gotham'
      fill_color 'FFFFFF'
      draw_text 'POWERED BY: prenzo.se', size: 4, style: :light, at: [bounds.left + 10, bounds.top - 10]
    end
  end

  def logo
    move_up 25
    logo = "#{Rails.root}/lib/bocado_logo_white.png"
    image logo, scale: 0.03, position: :right
  end

  def custom_text
    fill_color 'FFFFFF'
    font 'Gotham'
    draw_text 'LUNCH CARD', size: 16, style: :normal, at: [75, 70]
    draw_text "VALUE: #{@voucher.value}", size: 12, style: :light, at: [95, 55]
    fill_color '000000'
    text_block_position = 25
    draw_text "Code: #{@voucher.code}", at: [10, text_block_position], size: 11, style: :normal

    draw_text 'Please present card when placing order.', at: [10, text_block_position - 15], size: 6, style: :light
    draw_text "Purchased: #{@voucher.created_at.strftime('%B %Y')}. Valid until fully consumed!", at: [10, text_block_position - 23], size: 6, style: :light
  end

  def qr_code
    # canvas do
    #   # qr_png = Rails.env.test? ? @voucher.dark_qr_code_path : StringIO.open(@voucher.qr_dark.download)
    #   # image qr_png, scale: 0.8, position: :right, vposition: :bottom
    #   qr_png = Rails.env.test? ? @voucher.dark_qr_code_path : @voucher.qr_dark.download
    #   # binding.pry
    #   svg qr_png, position: :right, vposition: :bottom, width: 40
    # end

    padded_box([202, 46], 5, width: 50, height: 50) do
      qr_png = Rails.env.test? ? @voucher.dark_qr_code_path : @voucher.qr_dark.download
      # binding.pry
      svg qr_png, position: :right, vposition: :bottom, width: 40
    end
  end

  def generate_file
    @path = Rails.public_path.join('card.pdf')
    render_file(@path)
  end
end
