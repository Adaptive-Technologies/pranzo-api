# frozen_string_literal: true

require 'padded_box'
class CustomCardGenerator < Prawn::Document
  attr_reader :path
  include PaddedBox
  def initialize(voucher, render = true, variant = 1, locale = 'sv')
    I18n.locale = locale
    super({
      page_size: [144, 253],
      page_layout: :landscape,
      top_margin: 0,
      bottom_margin: 5,
      left_margin: 0, right_margin: 10
    })
    @voucher = voucher
    @variant = variant
    @path = nil
    font_families.update(
      'Gotham' => { bold: "#{Rails.root}/lib/assets/fonts/Gotham-Bold.ttf",
                    normal: "#{Rails.root}/lib/assets/fonts/Gotham-Medium.ttf",
                    light: "#{Rails.root}/lib/assets/fonts/Gotham-Light.ttf" }
    )
    case variant
    when 1
      background_centered
      powered_by
      logo('bocado')
      card_header_centered
      custom_text
      qr_code('dark', :right)
    when 2
      background_side_aligned
      powered_by
      logo('dummy')
      card_header_side_aligned(:right)
      qr_code('white', :left)
      card_value_side_aligned(:left)
      custom_text_side_aligned(:right)
    end
    generate_file if render
  end

  def background_centered
    canvas do
      svg IO.read("#{Rails.root}/lib/assets/color_1.svg"), at: [bounds.left - 5, bounds.top + 5], width: bounds.width + 10, height: bounds.height + 10
      svg IO.read("#{Rails.root}/lib/assets/tone_1.svg"), vposition: :top
      svg IO.read("#{Rails.root}/lib/assets/text_area_1.svg"), vposition: :bottom
    end
  end

  def background_side_aligned
    canvas do
      svg IO.read("#{Rails.root}/lib/assets/card_2_color_2.svg"), at: [bounds.left - 5, (bounds.top + 5)], width: (bounds.width + 10), height: (bounds.height + 10)
    end
  end

  def powered_by
    font 'Gotham'
    fill_color 'FFFFFF'
    draw_text 'POWERED BY', size: 4, style: :light, at: [bounds.left + 10, bounds.top - 10]
    svg IO.read("#{Rails.root}/lib/assets/pranzo_symbol.svg"), at: [bounds.left + 10, bounds.top - 12], width: 8
    draw_text 'PRENZO.SE', size: 8, style: :light, at: [bounds.left + 20, bounds.top - 20]
  end

  def logo(branding)
    if branding == 'bocado'
      # move_up 15
      move_up 18
      # logo = "#{Rails.root}/lib/bocado_logo_white.png"
      # image logo, scale: 0.03, position: :right
      logo = "#{Rails.root}/lib/fast_shopping_inverted.png"
      image logo, scale: 0.09, position: :right
    else
      move_up 18
      logo = "#{Rails.root}/lib/fast_shopping.png"
      image logo, scale: 0.02, position: :right

    end
  end

  def card_header_centered
    fill_color 'FFFFFF'
    font 'Gotham'
    draw_text I18n.t('voucher.title').gsub(' ', ''), size: 16, style: :normal, at: [75, 70]
    draw_text "#{I18n.t('voucher.value')} #{@voucher.value}", size: 12, style: :light, at: [95, 55]
  end

  def card_header_side_aligned(orientation)
    padded_box([102, 92.5], 5, width: 150, height: 75) do
      fill_color '79b92d'
      font 'Gotham'
      title = I18n.t('voucher.title').split(' ')
      text title[0], size: 20, style: :bold, align: orientation, leading: -5, character_spacing: 0.5
      fill_color '808080'
      text title[1], size: 20, style: :normal, align: orientation, leading: 1, character_spacing: 0.5
    end
  end

  def card_value_side_aligned(orientation)
    padded_box([65, 90], 5, width: 45, height: 45) do
      fill_color 'FFFFFF'
      font 'Gotham'
      text "#{I18n.t('voucher.value').upcase}", size: 4, style: :light, align: :center, valign: :top, leading: -10, character_spacing: 3
      text "#{@voucher.value}", size: 30, style: :bold, align: :center, valign: :center, leading: 0
    end
  end

  def custom_text
    fill_color '808080'
    text_block_position = 25
    draw_text "#{I18n.t('voucher.code')} #{@voucher.code}", at: [10, text_block_position], size: 11, style: :normal
    draw_text I18n.t('voucher.lead_text'), at: [10, text_block_position - 15], size: 6, style: :light
    draw_text I18n.t('voucher.validity', date: @voucher.created_at.strftime('%B %Y')), at: [10, text_block_position - 23], size: 6, style: :light
  end

  def custom_text_side_aligned(orientation)
    padded_box([82, 25], 5, width: 170, height: 30) do
      fill_color '808080'
      text_block_position = 25
      text I18n.t('voucher.lead_text'), align: orientation, valign: :top, size: 6, style: :light, leading: 1, character_spacing: 0.25
      text I18n.t('voucher.validity', date: @voucher.created_at.strftime('%B %Y')), align: orientation, size: 6, style: :light, leading: 1, character_spacing: 0.25
    end
  end

  def qr_code(mode, orientation)
    coords = mode == 'dark' ? [202, 46] : [5, 46]
    padded_box(coords, 5, width: 50, height: 50) do
      qr = Rails.env.test? ? @voucher.method("#{mode}_qr_code_path".to_sym).call : @voucher.method("qr_#{mode}".to_sym).call.download
      svg qr, position: orientation, vposition: :bottom, width: 40
    end
  end

  def generate_file
    @path = Rails.public_path.join('card.pdf')
    render_file(@path)
  end
end
