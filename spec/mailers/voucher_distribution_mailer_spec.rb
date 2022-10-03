RSpec.describe VoucherDistributionMailer, type: :mailer do
  let(:vendor) { create(:vendor, name: 'The Other Place') }
  let(:vendor_user) { create(:user, role: :vendor, name: 'Thomas', vendor: vendor) }
  let(:owner) { create(:owner, email: 'new_owner@random.com') }
  let(:voucher) { create(:servings_voucher, issuer: vendor_user, owner: owner, pass_kit_id: 'qwerty') }

  let(:mail) { VoucherDistributionMailer.activation(voucher) }
  before { voucher.generate_pdf_card }

  subject { mail }

  describe 'mail headers' do
    it 'is expected to have a subject' do
      expect(subject.subject).to eq('Ditt Pranzo kort hos The Other Place / Your Pranzo-card at The Other Place')
    end

    it 'is expected to have a recipient' do
      expect(subject.to).to eq(['new_owner@random.com'])
    end

    it 'is expected to have a sender' do
      expect(subject.from).to eq(['no-reply@pranzo.se'])
    end
  end

  describe 'attachments' do
    subject { mail.attachments }

    it 'is expected to be a pdf' do
      content_type = subject.first.content_type.split.first
      expect(content_type).to eq('application/pdf;')  
    end

    it 'is expected to have a file name' do
      file_name = subject.first.content_type.split.last
      expect(file_name).to eq('filename=12345-card.pdf')  
    end
  end

  describe 'html content' do
    subject { mail.body.parts.detect{|p| p.content_type.match(/text\/html/)}.body.to_s }

    it 'is expected to include a PassKit link' do
      expect(subject).to include "https://pub1.pskt.io/#{voucher.pass_kit_id}"
    end
  end
end
