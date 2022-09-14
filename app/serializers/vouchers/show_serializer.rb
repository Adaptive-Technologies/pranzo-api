class Vouchers::ShowSerializer < ActiveModel::Serializer
  attributes :id, :code, :active, :value, :current_value, :email
  has_many :transactions

  def current_value
    object.value - object.transactions.count
  end
end
