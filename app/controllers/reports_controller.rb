class ReportsController < ApplicationController
  before_action :get_period, only: :create
  before_action :get_vendor, only: :create
  def create
    transactions = @vendor.transactions.where(date: @period).group_by { |transaction| transaction.voucher.variant }
    ReportGeneratorService.generate({ period: @period, transactions: transactions.symbolize_keys, vendor: @vendor })
  end

  private

  def get_vendor
    @vendor = Vendor.find(params[:vendor_id])
  end

  def get_period
    @period = case params[:period]
              when 'today'
                Date.today.all_day
              when 'yesterday'
                1.day.ago.all_day
              when 'this_week'
                Date.today.all_week
              when 'last_week'
                1.week.ago.all_week
              when 'this_month'
                Date.today.all_month
              when 'last_month'
                1.month.ago.all_month
              else
                Date.today.all_day
              end
    @period
  end
end
