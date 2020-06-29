# frozen_string_literal: true

RSpec.describe TimeSheet, type: :model do
  describe 'Database table' do
    it { is_expected.to have_db_column :date }
    it { is_expected.to have_db_column :start_time }
    it { is_expected.to have_db_column :end_time }
    it { is_expected.to have_db_column :duration }
    it { is_expected.to have_db_column :created_at }
    it { is_expected.to have_db_column :updated_at }
  end

  describe 'Factory' do
    it {
      expect(create(:time_sheet)).to be_valid
    }
  end

  describe 'associations' do
    it {    is_expected.to belong_to(:user) }

  end
end
