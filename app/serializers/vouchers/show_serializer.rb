class Vouchers::ShowSerializer < ActiveModel::Serializer
  attributes :id, :code, :active, :value, :variant, :current_value, :email, :transactions
  has_many :transactions, serializer: Transactions::ShowSerializer

  def current_value
    object.value - object.transactions.count
  end

end
