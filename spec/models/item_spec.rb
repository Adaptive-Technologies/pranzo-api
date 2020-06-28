# frozen_string_literal: true

RSpec.describe Item, type: :model do
  describe 'Database table' do
    it {
      is_expected.to have_db_column(:order_id)
        .of_type(:integer)
    }
    it {
      is_expected.to have_db_column(:product_id)
        .of_type(:integer)
    }
  end

  describe 'Factory' do
    it {
      expect(create(:item)).to be_valid
    }
  end

  describe 'associations' do
    it {
      is_expected.to belong_to(:order)
        .optional(false)
    }
    it {
      is_expected.to belong_to(:product)
        .optional(false)
    }
  end
end
