# frozen_string_literal: true

RSpec.describe Voucher, type: :model do
  describe 'Database table' do
    it {
      is_expected.to have_db_column(:value)
        .of_type(:integer)
    }
    it {
      is_expected.to have_db_column(:active)
        .of_type(:boolean)
    }

    it {
      is_expected.to have_db_column(:issuer_id)
        .of_type(:integer)
    }

    it {
      is_expected.to have_db_column(:variant)
        .of_type(:integer)
    }

    it {
      is_expected.to have_db_column(:pass_kit_id)
        .of_type(:string)
    }

    it {
      is_expected.to have_db_column(:affiliate_network)
        .of_type(:boolean)
    }
  end

  describe 'factories' do
    it {
      expect(create(:voucher)).to be_valid
    }
    it {
      expect(create(:servings_voucher)).to be_valid
    }
    it {
      expect(create(:cash_voucher)).to be_valid
    }
  end

  describe 'attributes' do
    it { is_expected.to have_readonly_attribute(:code) }
    # TODO: should I make the variant attr read only?

    it {
      is_expected.to define_enum_for(:variant)
        .with_values(cash: 0, servings: 1)
    }
  end

  describe 'associations' do
    it {
      is_expected.to have_many(:transactions)
        .dependent(:destroy)
    }

    it {
      is_expected.to have_one(:owner)
        .dependent(:destroy)
    }

    describe 'belongs_to a owner that can be a user(role: consumer)' do
      let!(:user) { create(:consumer, email: 'registered@mail.com') }
      let!(:registered_owner) { create(:owner, user: user) }
      subject { create(:voucher, value: 10, owner: registered_owner) }

      it {
        expect(subject).to have_attributes(email: 'registered@mail.com')
      }
    end

    describe 'belongs_to a owner that do not have to be a user' do
      let!(:unregistered_owner) { create(:owner, user: nil, email: 'just_an@email.com') }
      subject { create(:voucher, value: 10, owner: unregistered_owner) }

      it {
        expect(subject).to have_attributes(email: 'just_an@email.com')
      }
    end

    describe '#issuer and #vendor' do
      let(:vendor) { create(:vendor) }
      let(:issuing_user) { create(:user, vendor: vendor) }
      subject { create(:voucher, issuer: issuing_user) }

      it { is_expected.to belong_to(:issuer) }
      it { is_expected.to have_one(:vendor).through(:issuer) }
    end
  end

  describe 'validations' do
    it {
      is_expected.to validate_presence_of :variant
    }
    it {
      is_expected.to validate_presence_of :value
    }

    describe ':transactions count for voucher with value 10' do
      subject { create(:voucher, value: 10) }
      let!(:transactions) do
        9.times do
          create(:transaction, voucher: subject)
        end
      end

      context 'on creating 10th transaction' do
        it 'is expected to be valid' do
          transaction = subject.transactions.new(attributes_for(:transaction))
          expect(transaction.save).to eq true
        end
      end

      context 'on creating 11th transaction' do
        let!(:last_valid_transaction) { create(:transaction, voucher: subject) }
        let(:transaction) { subject.transactions.new(attributes_for(:transaction)) }
        it 'is expected to be invalid' do
          expect(transaction.save).to eq false
        end

        it 'is expected to add error message to transaction' do
          transaction.save
          expect(
            transaction.errors.full_messages
          ).to include 'Voucher limit exceeded'
        end

        it 'is expected to add error message to voucher' do
          transaction.save
          expect(
            subject.errors.full_messages
          ).to include 'Voucher value limit exceeded'
        end
      end
    end

    describe ':transactions count for voucher with value 15' do
      subject { create(:voucher, value: 15) }
      let!(:transactions) do
        14.times do
          create(:transaction, voucher: subject)
        end
      end

      context 'on creating 15th transaction' do
        it 'is expected to be valid' do
          transaction = subject.transactions.new(attributes_for(:transaction))
          expect(transaction.save).to eq true
        end
      end

      context 'on creating 16th transaction' do
        let!(:last_valid_transaction) { create(:transaction, voucher: subject) }
        let(:transaction) { subject.transactions.new(attributes_for(:transaction)) }
        it 'is expected to be invalid' do
          expect(transaction.save).to eq false
        end

        it 'is expected to add error message to transaction' do
          transaction.save
          expect(
            transaction.errors.full_messages
          ).to include 'Voucher limit exceeded'
        end

        it 'is expected to add error message to voucher' do
          transaction.save
          expect(
            subject.errors.full_messages
          ).to include 'Voucher value limit exceeded'
        end
      end
    end
  end

  describe '#qr attributes' do
    let(:voucher) { create(:voucher) }
    describe 'white qr code transparent background (qr_white)' do
      subject { voucher.qr_white }

      it { is_expected.to be_attached }
      it { is_expected.to be_an_instance_of ActiveStorage::Attached::One }
    end

    describe 'black qr code transparent background (qr_dark)' do
      subject { voucher.qr_dark }

      it { is_expected.to be_attached }
      it { is_expected.to be_an_instance_of ActiveStorage::Attached::One }
    end
  end

  describe '#generate_pdf_card' do
    let(:vendor) { create(:vendor) }
    let(:user) { create(:user, vendor: vendor) }
    subject { create(:voucher, issuer: user) }
    it do
      expect do
        subject.generate_pdf_card
      end.to change { subject.pdf_card.attached? }.from(false).to(true)
    end
  end

  describe '#activate!' do
    describe 'inactive voucher' do
      subject { create(:voucher) }
      it do
        expect do
          subject.activate!
        end.to change { subject.active }.from(false).to(true)
      end
    end

    describe 'active voucher' do
      subject { create(:voucher, active: true) }
      it do
        expect do
          subject.activate!
        end.to change { subject.errors.details }
          .from({})
          .to({ base: [{ error: 'Voucher is already activated' }] })
      end
    end
  end

  describe '#current_value' do
    let(:vendor) { create(:vendor) }
    let(:user) { create(:user, vendor: vendor) }
    let!(:transaction) { create(:transaction, voucher: subject, amount: 200) }
    subject { create(:cash_voucher, value: 500, issuer: user) }
    it { is_expected.to respond_to :current_value }

    it 'is expected to return a value reduced by the sum of transactions' do
      expect(subject.current_value).to eq 300
    end
  end

  describe 'belonging to affiliates' do
    let(:vendor) { create(:vendor) }
    let(:affiliate) { create(:vendor) }
    let!(:voucher_1) do
      create(:cash_voucher, value: 500, issuer: vendor.system_user, affiliate_network: true, active: true)
    end
    let!(:voucher_2) do
      create(:cash_voucher, value: 500, issuer: vendor.system_user, affiliate_network: true, active: false)
    end
    let!(:affiliation) { vendor.affiliates << affiliate }

    it 'is expected to include in the "affiliated_vouchers" collection of :active' do
      expect(affiliate.affiliated_vouchers).to include(voucher_1)
    end

    it 'is expected NOT to include an voucher in the "affiliated_vouchers" collection if NOT :active' do
      expect(affiliate.affiliated_vouchers).not_to include(voucher_2)
    end
  end
end
