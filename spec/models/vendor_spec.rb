# frozen_string_literal: true

RSpec.describe Vendor, type: :model do
  subject { create(:vendor) }
  describe 'Database table' do
    it {
      is_expected.to have_db_column(:name)
        .of_type(:string)
    }
    it {
      is_expected.to have_db_column(:primary_email)
        .of_type(:string)
    }
  end
  describe 'Factory' do
    it {
      expect(create(:vendor)).to be_valid
    }
  end

  describe 'Validations' do
    it { is_expected.to validate_uniqueness_of :name }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to validate_presence_of :primary_email }
  end

  describe 'Associations' do
    it { is_expected.to have_many :addresses }
    it { is_expected.to have_many :users }
    it { is_expected.to have_many(:vouchers).through(:users) }
  end

  describe '#logotype' do
    subject { create(:vendor).logotype }

    it {
      is_expected.to be_an_instance_of ActiveStorage::Attached::One
    }
  end

  describe '#system_user' do
    let(:vendor) { create(:vendor, primary_email: 'my_primary@mail.com') }
    subject { vendor.system_user }
    it 'has the email of vendor' do
      expect(subject.email).to eq vendor.primary_email
    end
  end
end
