RSpec.describe VoucherDistributionMailer, type: :mailer do
  include Capybara::Email::DSL
  let(:vendor) { create(:vendor, name: 'The Other Place') }
  let(:vendor_user) { create(:user, role: :vendor, name: 'Thomas', vendor: vendor) }
  let(:owner) { create(:owner, email: 'new_owner@random.com') }
  let(:voucher) { create(:servings_voucher, issuer: vendor_user, owner: owner, pass_kit_id: 'qwerty') }
  before do
    voucher.generate_pdf_card
    VoucherDistributionMailer.activation(voucher).deliver_now
  end

  describe 'mail headers' do
    subject { open_email('new_owner@random.com') }

    it 'is expected to have a subject' do
      expect(subject.subject).to eq('Ditt klippkort hos The Other Place')
    end

    it 'is expected to have a recipient' do
      expect(subject.to).to eq(['new_owner@random.com'])
    end

    it 'is expected to have a sender' do
      expect(subject.from).to eq(['no-reply@pranzo.se'])
    end
  end

  describe 'attachments' do
    subject do
      open_email('new_owner@random.com').attachments
    end

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
    subject { open_email('new_owner@random.com') }

    it 'is expected to include a PassKit link' do
      expect(subject).to have_link href: "https://pub1.pskt.io/#{voucher.pass_kit_id}"
    end
  end
end
