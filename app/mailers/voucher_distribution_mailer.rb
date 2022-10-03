class VoucherDistributionMailer < ApplicationMailer
  default from: 'Pranzo (NO_REPY) <no-reply@pranzo.se>'

  def activation(voucher)
    @voucher = voucher
    voucher.pdf_card.attached? && attachments[voucher.pdf_card.filename.to_s] = open(@voucher.pdf_card_path).read
    mail(to: voucher.owner.email, subject: "Ditt Pranzo kort hos #{voucher.vendor.name} / Your Pranzo-card at #{voucher.vendor.name}")
  end
end
