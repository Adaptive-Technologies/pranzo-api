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
    it { is_expected.to have_many :affiliates }
    it { is_expected.to have_many(:affiliates).through(:affiliations) }
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

  describe 'Affiliate network' do
    subject { create(:vendor, name: 'The First Place', primary_email: 'primary_2@mail.com') }
    let(:vendor) { create(:vendor, name: 'The Second Place', primary_email: 'primary_1@mail.com') }
    let(:another_vendor) { create(:vendor, name: 'The Third Place', primary_email: 'primary_3@mail.com') }
    it do
      expect { subject.affiliates << vendor }.to change { subject.affiliations.count }.from(0).to(1)
    end

    describe ':#is_affiliated_with?' do
      it 'is expected to be respond true if affiliation exists ' do
        subject.affiliates << vendor
        expect(vendor.is_affiliated_with?(vendor_id: subject.id)).to eq true
      end

      it 'is expected to be respond false if no affiliation exists ' do
        subject.affiliates << vendor
        expect(vendor.is_affiliated_with?(vendor_id: another_vendor.id)).to eq false
      end
    end
  end
end
