class Products::ShowSerializer < ActiveModel::Serializer
  attributes :id, :title, :subtitle, :price, :imageUrl

  def imageUrl
    object.image_url
  end

  def title
    object.name
  end

  def subtitle
    'test'
  end
end
