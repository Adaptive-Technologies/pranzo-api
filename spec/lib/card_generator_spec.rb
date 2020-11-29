# frozen_string_literal: true

RSpec.describe CardGenerator do
  before do
    allow(SecureRandom).to receive(:alphanumeric).with(5).and_return('QQQQQ')
  end
  describe 'with a valid voucher' do
    subject { described_class.new(voucher) }
    let!(:voucher) { create(:voucher, value: 10) }
    let!(:pdf) do
      file = File.open(subject.path)
      PDF::Inspector::Text.analyze_file(file)
    end

    it {
      is_expected.to be_an_instance_of CardGenerator
    }

    it 'contains voucher data' do
      expect(pdf.strings)
        .to include('LUNCH VOUCHER')
        .and include('Code: QQQQQ Value: 10')
    end
  end
end
