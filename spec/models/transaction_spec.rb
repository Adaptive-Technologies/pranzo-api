# frozen_string_literal: true

RSpec.describe Transaction, type: :model do
  describe 'Database table' do
    it {
      is_expected.to have_db_column(:date)
        .of_type(:datetime)
    }
    it {
      is_expected.to have_db_column(:voucher_id)
        .of_type(:integer)
    }
  end

  describe 'Factory' do
    it {
      expect(create(:transaction)).to be_valid
    }
  end

  describe 'associations' do
    it {
      is_expected.to belong_to(:voucher)
        .optional(false)
    }
  end
end
