RSpec.describe Affiliation, type: :model do
  describe 'Factory' do
    it {
      expect(create(:affiliation)).to be_valid
    }
  end

  describe 'Database table' do
    it { is_expected.to have_db_column(:vendor_id).of_type(:integer) }
    it { is_expected.to have_db_column(:affiliate_id).of_type(:integer) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to :vendor }
    it { is_expected.to belong_to(:affiliate).class_name('Vendor') }
  end
end
