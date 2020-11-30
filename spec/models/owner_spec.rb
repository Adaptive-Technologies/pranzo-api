# frozen_string_literal: true

RSpec.describe Owner, type: :model do
  describe 'Database table' do
    it { is_expected.to have_db_column :email }
    it { is_expected.to have_db_column :user_id }
    it { is_expected.to have_db_column :voucher_id }
    it { is_expected.to have_db_column :created_at }
    it { is_expected.to have_db_column :updated_at }
  end

  describe 'Factory' do
    describe ':owner' do
      it {
        expect(create(:owner)).to be_valid
      }
    end

    describe ':owner_with_user' do
      it {
        expect(create(:owner_with_user)).to be_valid
      }
    end
  end

  describe 'associations' do
    it {
      is_expected.to belong_to(:user)
        .optional(true)
    }
    it {
      is_expected.to belong_to(:voucher)
        .optional(false)
    }
  end
end
