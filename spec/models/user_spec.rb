# frozen_string_literal: true

RSpec.describe User, type: :model do
  describe 'Database table' do
    it { is_expected.to have_db_column :name }
    it { is_expected.to have_db_column :email }
    it { is_expected.to have_db_column :encrypted_password }
    it { is_expected.to have_db_column :uid }
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
      is_expected.to have_many(:orders)
        .dependent(:destroy)
    }
  end
end
