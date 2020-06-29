# frozen_string_literal: true

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

  describe 'associations' do
    it {
      is_expected.to belong_to(:user)
        .optional(true)
    }
    it {
      is_expected.to have_many(:items)
        .dependent(:destroy)
    }
    it {
      is_expected.to have_many(:products)
        .through(:items)
    }

  end

  describe 'validations' do
  end
end
