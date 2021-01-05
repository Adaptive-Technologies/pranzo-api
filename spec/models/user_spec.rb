# frozen_string_literal: true

RSpec.describe User, type: :model do
  describe 'Database table' do
    it { is_expected.to have_db_column :name }
    it { is_expected.to have_db_column :email }
    it { is_expected.to have_db_column :encrypted_password }
    it { is_expected.to have_db_column :uid }
    it { is_expected.to have_db_column :created_at }
    it { is_expected.to have_db_column :updated_at }
    it {
      is_expected.to have_db_column(:role)
        .of_type(:integer)
    }
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
    it {
      is_expected.to have_many(:time_sheets)
        .dependent(:destroy)
    }

    it {
      is_expected.to belong_to(:vendor)
        .optional(true)
    }
  end

  describe '#role' do
    subject { create(:user) }
    it { is_expected.to respond_to :consumer? }
    it { is_expected.to respond_to :consumer! }
    it { is_expected.to respond_to :employee? }
    it { is_expected.to respond_to :employee! }
    it { is_expected.to respond_to :admin? }
    it { is_expected.to respond_to :admin! }
    it {
      expect do
        subject.employee!
      end.to change { subject.role }
        .from('consumer').to('employee')
    }
    it {
      expect do
        subject.admin!
      end.to change { subject.role }
        .from('consumer').to('admin')
    }
    it {
      subject.employee!
      expect do
        subject.consumer!
      end.to change { subject.role }
        .from('employee').to('consumer')
    }
  end
end
