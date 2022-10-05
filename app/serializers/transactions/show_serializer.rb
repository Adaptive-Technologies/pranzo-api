class Transactions::ShowSerializer < ActiveModel::Serializer
  attributes :id, :date, :amount

  def date
    object.date.to_fs(:long)
  end

end
