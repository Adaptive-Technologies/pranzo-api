# frozen_string_literal: true

require 'padded_box'
require 'nokogiri'
require 'open-uri'
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
    @vendor = voucher.vendor
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
      @svg_file = IO.read("#{Rails.root}/lib/assets/color_1.svg")
      set_card_color
      background_centered
      powered_by(:left)
      logo(true, :right)
      card_header_centered
      custom_text
      # custom_text_side_aligned(:right)
      qr_code('dark', :right)
    when 2 # updated
      @svg_file = IO.read("#{Rails.root}/lib/assets/card_2_color_2.svg")
      set_card_color
      background_side_aligned
      powered_by(:left)
      logo(true, :right)
      card_header_side_aligned(:right)
      qr_code('white', :left)
      card_value_side_aligned(:left)
      custom_text_side_aligned(:right)
    when 3
      @svg_file = IO.read("#{Rails.root}/lib/assets/card_3_color_6.svg")
      set_card_color
      background_side_aligned
      powered_by(:right)
      logo(true, :left)
      card_header_side_aligned(:left)
      qr_code('white-left', :right)
      card_value_side_aligned(:right)
      custom_text_side_aligned(:left)
    end
    generate_file if render
  end

  def set_card_color
    doc = Nokogiri::HTML.parse(@svg_file)
    @header_color = doc.xpath('//stop').map do |e|
      e[:style][/stop-color:([^;]*)/, 1]
    end.max_by(&:length).slice(1..6)
    @sub_header_color = @variant == 3 ? 'D3D3D3' : 'FFFFFF'
    @text_color = @variant == 3 ? 'D3D3D3' : '808080'
    @branding_color = @variant == (2 || 3) ? '808080' : 'FFFFFF'
  end

  def background_centered
    canvas do
      svg @svg_file, at: [bounds.left - 5, bounds.top + 5], width: bounds.width + 10, height: bounds.height + 10
      svg IO.read("#{Rails.root}/lib/assets/tone_1.svg"), vposition: :top
      svg IO.read("#{Rails.root}/lib/assets/text_area_1.svg"), vposition: :bottom
    end
  end

  def background_side_aligned
    canvas do
      svg @svg_file, at: [bounds.left - 5, (bounds.top + 5)], width: (bounds.width + 10), height: (bounds.height + 10)
    end
  end

  def powered_by(orientation)
    font 'Gotham'
    case orientation
    when :left
      powered_by_placement = top_placement(orientation, 10, '+', 10, '-')
      symbol_placement = top_placement(orientation, 10, '+', 12, '-')
      brand_placement = top_placement(orientation, 19, '+', 19, '-')
    when :right
      powered_by_placement = top_placement(orientation, 24, '-', 10, '-')
      symbol_placement = top_placement(orientation, 51, '-', 10.5, '-')
      brand_placement = top_placement(orientation, 43, '-', 18, '-')
    end
    fill_color @sub_header_color
    draw_text 'POWERED BY', size: 4, style: :light, at: powered_by_placement
    svg IO.read("#{Rails.root}/lib/assets/pranzo_symbol.svg"), at: symbol_placement, width: 7
    draw_text 'PRANZO.SE', size: 8, style: :light, at: brand_placement
  end

  def top_placement(orientation, horizontal_modifier, horizontal_type, vertical_modifier, vertical_type)
    if orientation == :right
      [bounds.send(orientation).send(horizontal_type, horizontal_modifier),
       bounds.top.send(vertical_type,
                       vertical_modifier)]
    else
      [bounds.send(orientation).send(horizontal_type, horizontal_modifier),
       bounds.top.send(vertical_type,
                       vertical_modifier)]
    end
  end

  def logo(branding, orientation)
    case orientation
    when :left
      box_position = top_placement(orientation, 5, '+', 1, '-')
    when :right
      box_position = top_placement(orientation, 190, '-', 1, '-')
    end
    if branding == true
      padded_box(box_position, 5, width: 200, height: 50) do
        if @vendor.logotype.attached?
          logo = Rails.env.test? ? open(@vendor.logotype_path) : URI.open(@vendor.logotype_path)
          image = Cairo::ImageSurface.from_png logo
          width = image.width
          fit_width = width.between?(700, 1200) ? width / 12.5 : width / 20
          image logo, position: orientation, vposition: :top, fit: [fit_width, 150]
        else
          # binding.pry
          font 'Gotham'

          fill_color @branding_color
          text @voucher.vendor.name.upcase, size: 10, align: orientation,
                                            style: :normal, leading: -5, character_spacing: 0.5
        end
      end

      move_up 30

    end
    # if branding == 'bocado'
    #   move_up 15
    #   logo = "#{Rails.root}/lib/bocado_logo_color.png"
    #   # logo = "#{Rails.root}/lib/fast_shopping_inverted.png"
    #   indent(orientation == :left ? 10 : 0) do
    #     image logo, scale: 0.15, position: orientation
    #     # image logo, scale: 0.09, position: orientation
    #   end
    # else
    #   move_up 15
    #   logo = "#{Rails.root}/lib/bocado_logo_color.png"
    #   image logo, scale: 0.15, position: orientation
    # end
  end

  def value_display
    display = if @voucher.cash?
                "#{@voucher.value}SEK"
              else
                @voucher.value
              end
  end

  def card_header_centered
    fill_color @sub_header_color
    font 'Gotham'
    move_down 35
    text I18n.t("voucher.title.#{@voucher.variant}").gsub(' ', ''), size: 16, style: :normal, align: :center

    text "#{I18n.t('voucher.value')} #{value_display}", size: 12, style: :light, align: :center
  end

  def card_header_side_aligned(orientation)
    case orientation
    when :left
      box_position = top_placement(orientation, 5, '+', 45, '-')
    when :right
      box_position = top_placement(orientation, 140, '-', 45, '-')
    end
    padded_box(box_position, 5, width: 150, height: 75) do
      font 'Gotham'
      fill_color @header_color
      title = I18n.t("voucher.title.#{@voucher.variant}").split(' ')
      text title[0], size: 20, style: :bold, align: orientation, leading: -5, character_spacing: 0.5
      fill_color @text_color
      text title[1], size: 20, style: :normal, align: orientation, leading: -5, character_spacing: 0.5
      text "#{I18n.t('voucher.code').upcase} #{@voucher.code}", size: 12, style: :normal, align: orientation,
                                                                character_spacing: 0.5
    end
  end

  def card_value_side_aligned(orientation)
    case orientation
    when :left
      box_position = top_placement(orientation, 65, '+', 50, '-')
    when :right
      box_position = top_placement(orientation, 100, '-', 50, '-')
    end
    padded_box(box_position, 5, width: 75, height: 45) do
      fill_color @sub_header_color
      font 'Gotham'

      if @voucher.servings?
        text I18n.t('voucher.value').upcase.to_s,
             size: 4, style: :light, align: :center, valign: :top, leading: -10, character_spacing: 3
        text @voucher.value.to_s, size: 30, style: :bold, align: :center, valign: :center, leading: 0
      end
      if @voucher.cash?
        text 'SEK',
             size: 8, style: :light, align: :center, valign: :top, leading: -10, character_spacing: 3
        text @voucher.value.to_s, size: 26, style: :bold, align: :center, valign: :center, leading: 0

      end
    end
  end

  def custom_text
    box_position = top_placement(:left, 5, '+', 100, '-')
    padded_box(box_position, 5, width: 190, height: 45) do
      fill_color @text_color
      font 'Gotham'
      text "#{I18n.t('voucher.code')} #{@voucher.code}"
      text "#{I18n.t('voucher.lead_text')} #{I18n.t('voucher.validity', date: @voucher.created_at.strftime('%B %Y'))}",
           align: :left, valign: :bottom, size: 5.5, style: :light, leading: 1, character_spacing: 0.15
    end
  end

  def custom_text_side_aligned(orientation)
    case orientation
    when :left
      box_position = top_placement(orientation, 5, '+', 113, '-')
    when :right
      box_position = top_placement(orientation, 160, '-', 113, '-')
    end
    padded_box(box_position, 5, width: 170, height: 30) do
      fill_color @text_color
      font 'Gotham'
      text "#{I18n.t('voucher.lead_text')} #{I18n.t('voucher.validity', date: @voucher.created_at.strftime('%B %Y'))}",
           align: orientation, valign: :bottom, size: 5.5, style: :light, leading: 1, character_spacing: 0.15
    end
  end

  def qr_code(mode, orientation)
    coords = case mode
             when 'dark'
               [202, 46]
             when 'white-left'
               [202, 46]
             else
               [5, 46]
             end
    padded_box(coords, 5, width: 50, height: 50) do
      qr = @voucher.method("qr_#{mode.gsub('-left', '')}".to_sym).call.download
      svg qr, position: orientation, vposition: :bottom, width: 35
    end
  end

  def generate_file
    @path = Rails.public_path.join('card.pdf')
    render_file(@path)
  end
end
