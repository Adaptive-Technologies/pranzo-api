# frozen_string_literal: true

RSpec.describe Category, type: :model do
  describe 'Database table' do
    it {
      is_expected.to have_db_column(:name)
        .of_type(:string)
    }
  end

  describe 'Translations' do
    subject { create(:category) }
    before do
      subject.update(promo: 'Swedish promo', locale: :sv)
    end

    after { I18n.locale = :en }

    it {
      is_expected.to respond_to(:translations)
    }

    it {
      is_expected.to respond_to(:promo)
    }

    it 'is expected to have multiple translations' do
      expect(subject.translations.count).to eq 2
    end

    it 'is expected to display translated value for the right locale' do
      I18n.locale = :sv
      expect(subject.promo).to eq 'Swedish promo'
    end
  end

  describe 'Factory' do
    it {
      expect(create(:category)).to be_valid
    }
  end

  describe 'associations' do
    it {
      is_expected.to have_and_belong_to_many(:products)
    }
  end
end
