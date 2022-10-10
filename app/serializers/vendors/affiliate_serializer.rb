class Vendors::AffiliateSerializer < ActiveModel::Serializer
  attributes :id, :name, :primary_email
  has_many :users, serializer: Users::ShowSerializer
end
