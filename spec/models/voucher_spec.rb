# frozen_string_literal: true

RSpec.describe Voucher, type: :model do
  describe 'Database table' do
    it {
      is_expected.to have_db_column(:value)
        .of_type(:integer)
    }
    it {
      is_expected.to have_db_column(:paid)
        .of_type(:boolean)
    }
  end

  describe 'Factory' do
    it {
      expect(create(:voucher)).to be_valid
    }
  end

  describe 'attributes' do
    it { is_expected.to have_readonly_attribute(:code) }
  end

  describe 'associations' do
    it {
      is_expected.to have_many(:transactions)
        .dependent(:destroy)
    }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_presence_of :paid }
    it { is_expected.to validate_presence_of :value }

    describe ':transactions count' do
      subject { create(:voucher) }
      let!(:transactions) { 10.times { create(:transaction, voucher: subject) } }
      it {
        expect(subject).to be_valid
      }
      it {
        transaction_attributes = attributes_for(:transaction)
        create(:transaction, voucher: subject)
        subject.reload
        binding.pry
        expect(subject).to_not be_valid
      }
    end
  end
end
