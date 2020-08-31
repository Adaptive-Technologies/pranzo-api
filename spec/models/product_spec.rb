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
    subject { create(:product) }

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
        subject.services = []
        subject.valid?
        expect(subject.errors[:services])
          .to include('must include at least one value')
      end
    end

    describe '#image_url' do
      it { is_expected.to validate_url_of(:image_url) }
      it 'is expected to be valid with a HTTPS url' do
        subject.image_url = 'https://picsum.photos/800'
        expect(subject.valid?).to be_truthy
      end

      it 'is expected to be valid with a HTTP url' do
        subject.image_url = 'http://picsum.photos/800'
        expect(subject.valid?).to be_truthy
      end

      it 'is expected NOT to be valid with an invalid protocol value (ftp)' do
        subject.image_url = 'ftp:/picsum.photos/800'
        subject.valid?
        expect(subject.errors[:image_url])
          .to include('is not a valid URL')
      end

      it 'is expected NOT to be valid with an invalid value' do
        subject.image_url = 'http:/picsum.photos/800'
        subject.valid?
        expect(subject.errors[:image_url])
          .to include('is not a valid URL')
      end

      it 'is expected NOT to be valid with an empty value' do
        subject.image_url = ''
        subject.valid?
        expect(subject.errors[:image_url])
          .to include('is not a valid URL')
      end

      it 'is expected NOT to be valid with an nil value' do
        subject.image_url = nil
        subject.valid?
        expect(subject.errors[:image_url])
          .to include('is not a valid URL')
      end
    end
  end

  describe 'Translations' do
    subject { create(:product) }
    before do
      subject.update(subtitle: 'Swedish subtitle', locale: :sv)
    end

    after { I18n.locale = :en }

    it {
      is_expected.to respond_to(:translations)
    }

    it {
      is_expected.to respond_to(:subtitle)
    }

    it 'is expected to have multiple translations' do
      expect(subject.translations.count).to eq 2
    end

    it 'is expected to display translated value for the right locale' do
      I18n.locale = :sv
      expect(subject.subtitle).to eq 'Swedish subtitle'
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

    it {
      is_expected.to have_and_belong_to_many(:categories)
    }
  end
end
