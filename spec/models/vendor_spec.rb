# frozen_string_literal: true

RSpec.describe Vendor, type: :model do
  describe 'Factory' do
    it {
      expect(create(:vendor)).to be_valid
    }
  end

  describe 'Associations' do
    # xit { is_expected.to have_and_belong_to_many :categories }
    it { is_expected.to have_many :addresses }
    it { is_expected.to have_many :users }
  end

  describe '#logotype' do
    subject { create(:vendor).logotype }

    it {
      is_expected.to be_an_instance_of ActiveStorage::Attached::One
    }
  end
end
