class Users::ShowSerializer < ActiveModel::Serializer
  attributes :id, :email, :name
end
