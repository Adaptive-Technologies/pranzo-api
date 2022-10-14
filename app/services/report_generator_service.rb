module ReportGeneratorService
  def self.generate(data)
    cash_transactions = data[:transactions][:cash]
    consumption_transactions = data[:transactions][:servings]

    # clean_transactions = consumption_transactions.uniq { |t| t.date.strftime('%Y-%m-%d') }
    # clean_transactions = JSON.parse(clean_transactions.to_json, symbolize_names: true)
    # transactions = JSON.parse(consumption_transactions.to_json, symbolize_names: true)
    # clean_transactions.each do |clean_tran|
    #   transaction_count = transactions.reduce(1) do |num, trans|
    #     trans[:date].to_date.strftime('%Y-%m-%d') == clean_tran[:date].to_date.strftime('%Y-%m-%d') ? ++num : num
    #   end
    #   clean_tran[:count] = transaction_count
    #   binding.pry
    # end
    report_data = { vendor: data[:vendor],
                    cash_transactions: cash_transactions,
                    consumption_transactions: consumption_transactions,
                    cash_total: cash_transactions.pluck(:amount).sum,
                    consumption_total: consumption_transactions.pluck(:amount).sum,
                    report_period: {
                      beginning: data[:period].begin.strftime('%Y-%m-%d'),
                      end: data[:period].end.strftime('%Y-%m-%d')
                    } }
    ReportGenerator.new(report_data)
  end
end
