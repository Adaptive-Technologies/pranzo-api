# frozen_string_literal: true

RSpec.describe CustomCardGenerator do
  let(:pdf) do
    file = File.open(subject.path)
    PDF::Inspector::Text.analyze_file(file)
  end
  before do
    allow(SecureRandom).to receive(:alphanumeric)
      .with(5)
      .and_return('12345')
  end
  describe 'with a valid voucher' do
    context 'swedish version' do
      describe 'of variant :servings' do
        let(:servings_voucher) { create(:servings_voucher, value: 10) }
        context 'using design 1' do
          subject { described_class.new(servings_voucher, true, 1, :sv) }

          it {
            is_expected.to be_an_instance_of CustomCardGenerator
          }

          it 'is expected to contain voucher data' do
            expect(pdf.strings)
              .to include('LUNCHKORT')
              .and include('Kod: 12345')
              .and include('VÄRDE 10')
          end
        end

        context 'using design 2' do
          subject { described_class.new(servings_voucher, true, 2, :sv) }

          it {
            is_expected.to be_an_instance_of CustomCardGenerator
          }

          it 'is expected to contain voucher data' do
            expect(pdf.strings)
              .to include('LUNCH')
              .and include('KORT')
              .and include('KOD: 12345')
              .and include('VÄRDE')
              .and include('10')
          end
        end
      end

      describe 'of variant :cash' do
        let(:cash_voucher) { create(:cash_voucher, value: 200) }
        context 'using design 1' do
          subject { described_class.new(cash_voucher, true, 1, :sv) }
          
          it {
            is_expected.to be_an_instance_of CustomCardGenerator
          }

          it 'is expected to contain voucher data' do
            expect(pdf.strings)
              .to include('PRESENTKORT')
              .and include('Kod: 12345')
              .and include('VÄRDE 200SEK')
          end
        end

        context 'using design 2' do
          let!(:cash_voucher) { create(:cash_voucher, value: 200) }
          subject { described_class.new(cash_voucher, true, 2, :sv) }

          it {
            is_expected.to be_an_instance_of CustomCardGenerator
          }

          it 'is expected to contain voucher data' do
            expect(pdf.strings)
              .to include('PRESENT')
              .and include('KORT')
              .and include('KOD: 12345')
              .and include('SEK')
              .and include('200')
          end
        end
      end
    end

    context 'english version' do
      let(:servings_voucher) { create(:servings_voucher, value: 10) }
      describe 'of variant :servings' do
        context 'using design 1' do
          subject { described_class.new(servings_voucher, true, 1, :en) }

          it {
            is_expected.to be_an_instance_of CustomCardGenerator
          }

          it 'is expected to contain voucher data' do
            expect(pdf.strings)
              .to include('LUNCHCARD')
              .and include('Code: 12345')
              .and include('VALUE 10')
          end
        end

        context 'using design 2' do
          subject { described_class.new(servings_voucher, true, 2, :en) }
          it {
            is_expected.to be_an_instance_of CustomCardGenerator
          }

          it 'is expected to contain voucher data' do
            expect(pdf.strings)
              .to include('LUNCH')
              .and include('CARD')
              .and include('CODE: 12345')
              .and include('VALUE')
              .and include('10')
          end
        end
      end

      describe 'of variant :cash' do
        let(:cash_voucher) { create(:cash_voucher, value: 200) }
        context 'using design 1' do
          subject { described_class.new(cash_voucher, true, 1, :en) }

          it {
            is_expected.to be_an_instance_of CustomCardGenerator
          }

          it 'is expected to contain voucher data' do
            expect(pdf.strings)
              .to include('GIFTCARD')
              .and include('Code: 12345')
              .and include('VALUE 200SEK')
          end
        end

        context 'using design 2' do
          subject { described_class.new(cash_voucher, true, 2, :en) }
          it {
            is_expected.to be_an_instance_of CustomCardGenerator
          }

          it 'is expected to contain voucher data' do
            expect(pdf.strings)
              .to include('GIFT')
              .and include('CARD')
              .and include('CODE: 12345')
              .and include('SEK')
              .and include('200')
          end
        end
      end
    end
  end
end
