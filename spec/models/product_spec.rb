# frozen_string_literal: true

RSpec.describe Product, type: :model do
  describe 'Database table' do
    it { is_expected.to have_db_column :name }
    it {
      is_expected.to have_db_column(:price)
        .of_type(:decimal)
        .with_options(precision: 8, scale: 2, null: false)
    }
    it {
      is_expected.to have_db_column(:services)
        .of_type(:text)
        .with_options(array: true, default: [])
    }
  end

  describe 'Validations' do
    describe '#services' do
      it 'contains "lunch"' do
        subject.services << 'lunch'
        expect(subject.valid?).to be_truthy
      end

      it 'contains "dinner"' do
        subject.services << 'lunch'
        expect(subject.valid?).to be_truthy
      end

      it 'contains an invalid value' do
        subject.services << 'something_invalid'
        subject.valid?
        expect(subject.errors[:services])
          .to include('"something_invalid" is an invalid value')
      end

      it 'is an empty array' do
        subject.valid?
        expect(subject.errors[:services])
          .to include('must include at least one value')
      end
    end
  end

  describe 'Factory' do
    it {
      expect(create(:product)).to be_valid
    }
  end
  describe 'associations' do
    it { is_expected.to have_many(:items) }
    it {
      is_expected.to have_many(:orders)
        .through(:items)
    }
  end
end
