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
    it { is_expected.to belong_to(:user) }
  end

  describe 'scopes' do
    let(:user) { create(:user) }
    let!(:time_sheets) do
      create(:time_sheet, date: Date.today.beginning_of_month + 15, user: user, start_time: '09:00', end_time: '15:00')
      create(:time_sheet, date: Date.today.beginning_of_month + 16, user: user, start_time: '09:00', end_time: '15:00')
      create(:time_sheet, date: Date.today.months_ago(1).beginning_of_month + 15, user: user, start_time: '09:00', end_time: '15:00')
      create(:time_sheet, date: Date.today.months_ago(1).beginning_of_month + 16, user: user, start_time: '09:00', end_time: '15:00')
      create(:time_sheet, date: Date.today.months_ago(1).beginning_of_month + 17, user: user, start_time: '09:00', end_time: '15:00')

    end
    describe '#all' do
      it 'is expected to return all instances' do
        expect(TimeSheet.all.count).to eq 5
      end
    end

    describe '#for_current_period' do
      it 'is expected to return instances for the curreent month period' do
        expect(TimeSheet.for_current_period.count).to eq 2
      end
    end

    describe '#for_previous_period' do
      it 'is expected to return instances for the previous month period' do
        expect(TimeSheet.for_previous_period.count).to eq 3
      end
    end
  end
end
