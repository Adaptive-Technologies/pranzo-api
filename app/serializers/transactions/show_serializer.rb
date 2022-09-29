class Transactions::ShowSerializer < ActiveModel::Serializer
  attributes :id, :date

  def date
    object.date.to_fs(:long)
  end

end
