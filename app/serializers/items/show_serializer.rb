class Items::ShowSerializer < ActiveModel::Serializer
  attributes :id, :product_id, :name, :price

  def name
    object.product.name
  end

  def price
    object.product.price
  end
end
