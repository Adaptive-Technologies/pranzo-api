# frozen_string_literal: true
RSpec.describe Product, type: :model do
  describe 'Database table' do
    it { is_expected.to have_db_column :name }
    it {
      is_expected.to have_db_column(:price)
        .of_type(:decimal)
        .with_options(precision: 8, scale: 2, null: false)
    }
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
