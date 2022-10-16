RSpec.describe ReportAndStatsMailer, type: :mailer do
  let(:vendor) { create(:vendor, name: 'The Other Place') }
  let(:user) { create(:user, role: :vendor, name: 'Thomas', vendor: vendor) }
  let(:create_report) do
    transactions = vendor.transactions
                          .where(date: Date.today)
                          .order('created_at ASC')
                          .group_by { |transaction| transaction.voucher.variant }
    ReportGeneratorService.generate({
                                      period: @period,
                                      transactions: transactions.symbolize_keys,
                                      vendor: @vendor
                                    })

    
  end
  let(:report) { open(Rails.public_path.join('report.pdf')) }


  describe 'distribute' do
    subject { described_class.distribute(report, user).deliver }

    it 'is expected to have a recipient' do
      expect(subject.to).to eq([vendor.primary_email, user.email])
    end

    it 'is expected to have a sender' do
      expect(subject.from).to eq(['no-reply@pranzo.se'])
    end

    it 'is expected to have a pdf attachment' do
      content_type = subject.attachments.first.content_type.split.first
      expect(content_type).to eq('application/pdf;')  
    end
  end
end
