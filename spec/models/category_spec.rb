
RSpec.describe Category, type: :model do
  describe 'Database table' do
    it {
      is_expected.to have_db_column(:name)
        .of_type(:string)
    }

  end

  describe 'Translations' do
    it {
      is_expected.to respond_to(:translations)
    }
    
    it {
      is_expected.to respond_to(:promo)
    }
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
