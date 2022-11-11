# frozen_string_literal: true

RSpec.describe CustomCardGenerator do
  let(:vendor) { create(:vendor, name: 'Lerjedalens Spis & Bar') }
  let(:logotype) do
    File.read(fixture_path + '/files/logotype.txt')
  end
  let(:user) { create(:user, vendor: vendor) }
  let(:pdf) do
    file = File.open(subject.path)
    PDF::Inspector::Text.analyze_file(file)
  end

  describe 'with a valid voucher' do
    before do
      vendor.logotype.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'bjorsjoas_logo_old_black.png')),
      filename: "logo_#{vendor.name.downcase.parameterize(separator: '_')}.png",
      content_type: 'image/png')
    end
    context 'swedish version' do
      describe 'of variant :servings' do
        let(:servings_voucher) { create(:servings_voucher, value: 10, issuer: user) }
        context 'using design 1' do
          subject { described_class.new(servings_voucher, true, 1, :sv) }

          it {
            is_expected.to be_an_instance_of CustomCardGenerator
          }

          it 'is expected to contain voucher data' do
            expect(pdf.strings)
              .to include('KLIPPKORT')
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
            # binding.pry
            expect(pdf.strings)
              .to include('KLIPP')
              .and include('KORT')
              .and include('KOD: 12345')
              .and include('VÄRDE')
              .and include('10')
          end
        end
      end

      describe 'of variant :cash' do
        let(:cash_voucher) { create(:cash_voucher, value: 1000, issuer: user) }
        context 'using design 1' do
          subject { described_class.new(cash_voucher, true, 1, :sv) }

          it {
            is_expected.to be_an_instance_of CustomCardGenerator
          }

          it 'is expected to contain voucher data' do
            expect(pdf.strings)
              .to include('PRESENTKORT')
              .and include('Kod: 12345')
              .and include('VÄRDE 1000SEK')
          end
        end

        context 'using design 2' do
          let!(:cash_voucher) { create(:cash_voucher, value: 200, issuer: user) }
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

        context 'using design 3' do
          let!(:cash_voucher) { create(:cash_voucher, value: 1000, issuer: user) }
          subject { described_class.new(cash_voucher, true, 3, :sv) }

          it {
            is_expected.to be_an_instance_of CustomCardGenerator
          }

          it 'is expected to contain voucher data' do
            expect(pdf.strings)
              .to include('PRESENT')
              .and include('KORT')
              .and include('KOD: 12345')
              .and include('SEK')
              .and include('1000')
          end
        end
      end
    end

    context 'english version' do
      let(:servings_voucher) { create(:servings_voucher, value: 10, issuer: user) }
      describe 'of variant :servings' do
        context 'using design 1' do
          subject { described_class.new(servings_voucher, true, 1, :en) }

          it {
            is_expected.to be_an_instance_of CustomCardGenerator
          }

          it 'is expected to contain voucher data' do
            expect(pdf.strings)
              .to include('PUNCH CARD')
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
              .to include('PUNCH')
              .and include('CARD')
              .and include('CODE: 12345')
              .and include('VALUE')
              .and include('10')
          end
        end
      end

      describe 'of variant :cash' do
        let(:cash_voucher) { create(:cash_voucher, value: 200, issuer: user) }
        context 'using design 1' do
          subject { described_class.new(cash_voucher, true, 1, :en) }

          it {
            is_expected.to be_an_instance_of CustomCardGenerator
          }

          it 'is expected to contain voucher data' do
            expect(pdf.strings)
              .to include('GIFT CARD')
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
