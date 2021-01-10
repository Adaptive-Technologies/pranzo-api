# frozen_string_literal: true

RSpec.describe CustomCardGenerator do
  before do
    allow(SecureRandom).to receive(:alphanumeric).with(5).and_return('QQQQQ')
  end
  describe 'with a valid voucher' do
    let!(:voucher) { create(:voucher, value: 10) }
    subject { described_class.new(voucher, true, 1, :en) }
    let(:pdf) do
      file = File.open(subject.path)
      PDF::Inspector::Text.analyze_file(file)
    end

    it {
      is_expected.to be_an_instance_of CustomCardGenerator
    }

    it 'is expected to contain voucher data' do
      expect(pdf.strings)
        .to include('LUNCHCARD')
        .and include('Code: QQQQQ')
        .and include('VALUE 10')
    end
  end
end
