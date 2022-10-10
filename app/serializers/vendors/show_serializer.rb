class Vendors::ShowSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :primary_email, :affiliates
  has_many :users, serializer: Users::ShowSerializer
  has_many :addresses, serializer: Addresses::ShowSerializer
end
