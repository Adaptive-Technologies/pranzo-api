class ReportAndStatsMailer < ApplicationMailer
  default from: 'Pranzo - NO_REPLY <no-reply@pranzo.se>'

  def distribute(report, current_user)
    attachments['report.pdf'] = File.read(report.path)
    @user = current_user
    @vendor = current_user.vendor
    @greeting = 'Hi'

    mail to: [current_user.vendor.primary_email, current_user.email], subject: 'Rapport från PRANZO'
  end
end
