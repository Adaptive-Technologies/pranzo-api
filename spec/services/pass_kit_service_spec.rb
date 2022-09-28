RSpec.describe PassKitService do
  before do
    allow(SecureRandom).to receive(:alphanumeric)
      .with(5)
      .and_return('12345')
  end
  let(:vendor) { create(:vendor, name: 'Lerjedalens Spis & Bar') }
  let(:user) { create(:user, vendor: vendor) }
  let!(:voucher) { create(:servings_voucher, value: 10, issuer: user) }
  describe '#enroll' do
    subject { described_class.enroll(voucher.code, voucher.value) }

    before { subject }

    it 'is expected to make a call to API enrollemnt endpoint' do
      expect(a_request(:post, 'https://api.pub1.passkit.io/members/member')
      .with(body: hash_including({ externalId: '12345', points: 10 }))).to have_been_made.once
    end
  end

  describe '#consume' do
    subject { described_class.consume(voucher.code, 1) }

    before { subject }

    it 'is expected to make a call to API burn points endpoint' do
      expect(a_request(:put, 'https://api.pub1.passkit.io/members/member/points/burn')
      .with(body: hash_including({ externalId: '12345', points: 1 }))).to have_been_made.once
    end
  end

  describe '#refill' do
    subject { described_class.refill(voucher.code, 10) }

    before { subject }

    it 'is expected to make a call to API earn points endpoint' do
      expect(a_request(:put, 'https://api.pub1.passkit.io/members/member/points/earn')
      .with(body: hash_including({ externalId: '12345', points: 10 }))).to have_been_made.once
    end
  end
end
