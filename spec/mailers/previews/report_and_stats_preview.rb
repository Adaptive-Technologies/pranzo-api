# Preview all emails at http://localhost:3000/rails/mailers/report_and_stats
class ReportAndStatsPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/report_and_stats/distribute
  def distribute
    ReportAndStatsMailer.distribute
  end

end
