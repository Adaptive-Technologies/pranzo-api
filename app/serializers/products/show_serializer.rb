# frozen_string_literal: true

class Products::ShowSerializer < ActiveModel::Serializer
  attributes :id, :title, :subtitle, :price, :imageUrl

  def imageUrl
    object.image_url
  end

  def title
    object.name
  end

  def subtitle
    subtitle_object = {}
    object.translations.each do |translation|
      subtitle_object[translation.locale.to_sym] = translation.subtitle
    end
    subtitle_object
  end
end
