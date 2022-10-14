require 'padded_box'
class ReportGenerator < Prawn::Document
  include PaddedBox
  PAGE_OPTIONS = {
    page_size: 'A4',
    page_layout: :portrait,
    top_margin: 20,
    bottom_margin: 20,
    left_margin: 30,
    right_margin: 30
  }.freeze

  def initialize(report_data)
    super(PAGE_OPTIONS)
    font_families.update(
      'Gotham' => { bold: "#{Rails.root}/lib/assets/fonts/Gotham-Bold.ttf",
                    normal: "#{Rails.root}/lib/assets/fonts/Gotham-Medium.ttf",
                    light: "#{Rails.root}/lib/assets/fonts/Gotham-Light.ttf" }
    )
    @vendor = report_data[:vendor]
    @top_position = 700
    @daily_report = report_data[:report_period][:end] == report_data[:report_period][:beginning]
    logo
    generate_header(report_data[:report_period])
    generate_footer(report_data[:report_period])
    generate_boxes(report_data)

    generate_file
  end

  def logo
    logotype = "#{Rails.root}/lib/pranzo_color.png"
    move_down 30
    image logotype, scale: 0.1, position: :right
  end

  def generate_header(data)
    message = !@daily_report ? "Period #{data[:beginning]} - #{data[:end]}" : "Datum: #{data[:beginning]}"
    font 'Gotham'
    draw_text @vendor.name, size: 24, style: :normal, at: [1, @top_position + 50], color: '000000'
    draw_text 'KASSARAPPORT - bilaga', size: 20, style: :light, at: [1, @top_position], color: '000000'
    draw_text message, size: 12, style: :light, at: [1, (@top_position - 20)], color: '000000'
  end

  def generate_footer(data)
    draw_text "#{@vendor.name} KASSARAPPORT - bilaga. #{data[:beginning]} #{data[:end] != data[:beginning] ? ' - ' + data[:end] : ''}",
              size: 10, style: :light, at: [1, 10], color: '000000'
  end

  def generate_boxes(report_data)
    padded_box([1, (@top_position - 70)], 1, width: 200, height: 50) do
      generate_consuption_card_usage(report_data[:consumption_transactions], report_data[:consumption_total])
      generate_cash_card_usage(report_data[:cash_transactions], report_data[:cash_total])
    end
  end

  def generate_cash_card_usage(transactions, total)
    top_of_box = 50
    row_height = 20
    row = top_of_box - 40
    transactions = JSON.parse(transactions.to_json, symbolize_names: true)
    draw_text 'PRESENTKORT', size: 14, style: :normal, at: [260, top_of_box], color: '000000'
    draw_text "Totalt mottaget: #{total} kr.", size: 12, style: :light, at: [260, top_of_box - 20], color: '000000'

    if @daily_report
      draw_text 'Kl', size: 12, style: :normal, at: [260, row], color: '000000'
      draw_text 'Mottaget', size: 12, style: :normal, at: [380, row], color: '000000'
      transactions.each do |transaction|
        row -= row_height
        draw_text transaction[:date].to_datetime.strftime('%H:%M'), size: 12, style: :light, at: [260, row],
                                                                       color: '000000'
        draw_text "#{transaction[:amount]} kr", size: 12, style: :light, at: [380, row], color: '000000'
      end
    else
      clean_transactions = JSON.parse(transactions.uniq do |t|
        t[:date].to_date.strftime('%Y-%m-%d')
      end.to_json, symbolize_names: true)
      clean_transactions.each do |clean_tran|
        transaction_amount = transactions.reduce(0) do |num, trans|
          trans[:date].to_date.strftime('%Y-%m-%d') == clean_tran[:date].to_date.strftime('%Y-%m-%d') ? num += trans[:amount] : num
        end
        clean_tran[:aggregated_amount] = transaction_amount
      end
      clean_transactions.each do |clean_tran|
        transaction_count = transactions.reduce(0) do |num, trans|
          trans[:date].to_date.strftime('%Y-%m-%d') == clean_tran[:date].to_date.strftime('%Y-%m-%d') ? num  += 1 : num
        end
        clean_tran[:aggregated_count] = transaction_count
      end
      draw_text 'Datum', size: 12, style: :normal, at: [260, row], color: '000000'
      draw_text 'Total', size: 12, style: :normal, at: [380, row], color: '000000'
      draw_text 'Antal mottagna', size: 12, style: :normal, at: [440, row], color: '000000'
      clean_transactions.each do |transaction|
        row -= row_height
        draw_text transaction[:date].to_datetime.strftime('%Y-%m-%d'), size: 12, style: :light, at: [260, row],
                                                                       color: '000000'
        draw_text "#{transaction[:aggregated_amount]} kr", size: 12, style: :light, at: [380, row], color: '000000'
        draw_text "#{transaction[:aggregated_count]} st", size: 12, style: :light, at: [440, row], color: '000000'
      end
    end
  end

  def generate_consuption_card_usage(transactions, total)
    top_of_box = 50
    row_height = 20
    row = top_of_box - 40
    transactions = JSON.parse(transactions.to_json, symbolize_names: true)

    draw_text 'FÖRBRUKNINGSKORT', size: 14, style: :normal, at: [1, top_of_box], color: '000000'
    draw_text "Totalt mottagna: #{total} st.", size: 12, style: :light, at: [1, top_of_box - 20], color: '000000'
    if @daily_report
      draw_text 'Kl', size: 12, style: :normal, at: [1, row], color: '000000'
      draw_text 'Antal', size: 12, style: :normal, at: [200, row], color: '000000'
      transactions.each do |transaction|
        row -= row_height
        draw_text transaction[:date].to_datetime.strftime('%H:%M'), size: 12, style: :light, at: [1, row],
                                                                    color: '000000'
        draw_text transaction[:amount], size: 12,
                                        style: :light, at: [200, row], color: '000000'
      end

    else
      draw_text 'Datum', size: 12, style: :normal, at: [1, row], color: '000000'
      draw_text 'Antal', size: 12, style: :normal, at: [200, row], color: '000000'

      clean_transactions = JSON.parse(transactions.uniq do |t|
                                        t[:date].to_date.strftime('%Y-%m-%d')
                                      end.to_json, symbolize_names: true)
      clean_transactions.each do |clean_tran|
        transaction_count = transactions.reduce(0) do |num, trans|
          trans[:date].to_date.strftime('%Y-%m-%d') == clean_tran[:date].to_date.strftime('%Y-%m-%d') ? num += trans[:amount] : num
        end
        clean_tran[:count] = transaction_count
      end
      clean_transactions.each do |transaction|
        row -= row_height
        draw_text transaction[:date].to_datetime.strftime('%Y-%m-%d'), size: 12, style: :light, at: [1, row],
                                                                       color: '000000'
        draw_text transaction[:count], size: 12, style: :light, at: [200, row], color: '000000'
      end
    end
  end

  def generate_file
    @path = Rails.public_path.join('report.pdf')
    render_file(@path)
  end
end
