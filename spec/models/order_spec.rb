RSpec.describe Order, type: :model do
  describe 'Database table' do
    it { is_expected.to have_db_column :created_at }
    it { is_expected.to have_db_column :updated_at }
  end

  describe 'Factory' do
    it {
      expect(create(:order)).to be_valid
    }

  end
end
