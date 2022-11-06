class VoucherDistributionMailer < ApplicationMailer
  default from: 'Pranzo - NO_REPLY <no-reply@pranzo.se>'
  layout false
  def activation(voucher)
    @voucher = voucher
    voucher.pdf_card.attached? && attachments[voucher.pdf_card.filename.to_s] = @voucher.pdf_card.download
    mail(to: voucher.owner.email,
         from: "#{@voucher.vendor.name}/Pranzo - NO_REPLY <no-reply@pranzo.se>",
         subject: "Ditt #{voucher.variant == 'servings' ? 'klippkort' : 'presentkort'} hos #{voucher.vendor.name}") do |format|
      format.mjml
    end
  end
end
