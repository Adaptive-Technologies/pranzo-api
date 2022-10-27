class Vendors::ShowSerializer < ActiveModel::Serializer
  attributes :id, :name, :legal_name, :description, :primary_email, :vat_id
  has_many :affiliates, serializer: Vendors::AffiliateSerializer
  has_many :users, serializer: Users::ShowSerializer
  has_many :addresses, serializer: Addresses::ShowSerializer

end
