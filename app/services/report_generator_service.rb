module ReportGeneratorService

  def self.generate(data)
    vendor = data[:vendor]
    cash_transactions = data[:transactions][:cash]
    consumption_transactions = data[:transactions][:servings]
    cash_total = cash_transactions.pluck(:amount).sum
    consumption_total = consumption_transactions.pluck(:amount).sum
    report_period = {beginning: data[:period].begin.strftime('%Y-%m-%d'), end: data[:period].end.strftime('%Y-%m-%d')}
    binding.pry
  end
end