
RSpec.describe Category, type: :model do
  describe 'Database table' do
    it {
      is_expected.to have_db_column(:name)
        .of_type(:string)
    }
    it {
      is_expected.to have_db_column(:promo)
        .of_type(:text)
    }
  end

  describe 'Factory' do
    it {
      expect(create(:category)).to be_valid
    }
  end
end
