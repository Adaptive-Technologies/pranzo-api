class Addresses::ShowSerializer < ActiveModel::Serializer
  attributes :street, :post_code, :city, :country
end
