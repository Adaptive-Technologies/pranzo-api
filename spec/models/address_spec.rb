# frozen_string_literal: true

RSpec.describe Address, type: :model do
  describe 'Factory' do
    it {
      expect(create(:vendor)).to be_valid
    }
  end

  describe 'Database table' do
    it { is_expected.to have_db_column :street }
    it { is_expected.to have_db_column :post_code }
    it { is_expected.to have_db_column :city }
    it { is_expected.to have_db_column :country }
    it { is_expected.to have_db_column :created_at }
    it { is_expected.to have_db_column :updated_at }
    it {
      is_expected.to have_db_column(:latitude)
        .of_type(:float)
    }
    it {
      is_expected.to have_db_column(:longitude)
        .of_type(:float)
    }
  end

  describe 'Associations' do
    it { is_expected.to belong_to :vendor }
  end

  describe 'Geolocation' do
    let(:vendor) { create(:vendor) }
    subject { vendor.addresses.new(attributes_for(:address)) }
    describe 'unsaved address' do
      it 'has no longitude' do
        expect(subject.longitude).to eq nil
      end
      it 'has no latitude' do
        expect(subject.latitude).to eq nil
      end
    end

    describe 'persisted address' do
      before do
        subject.save
      end
      it 'has longitude' do
        expect(subject.longitude).to_not eq nil
      end
      it 'has latitude' do
        expect(subject.latitude).to_not eq nil
      end
    end
  end
end
