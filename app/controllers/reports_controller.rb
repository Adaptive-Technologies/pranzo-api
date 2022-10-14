class ReportsController < ApplicationController
  def create
    ReportGeneratorService.generate(params)
  end
end
