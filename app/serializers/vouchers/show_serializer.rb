class Vouchers::ShowSerializer < ActiveModel::Serializer
  attributes :id, :code, :active, :value, :variant, :current_value, :email, :affiliate_network
  belongs_to :vendor, serializer: Vendors::AffiliateSerializer, if: :is_available_to_affiliates?
  has_many :transactions, serializer: Transactions::ShowSerializer

  def is_available_to_affiliates?
    object.affiliate_network 
  end

end
