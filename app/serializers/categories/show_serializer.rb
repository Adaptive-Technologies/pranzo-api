# frozen_string_literal: true

class Categories::ShowSerializer < ActiveModel::Serializer
  attributes :promo

  def promo
    promo_object = {}
    object.translations.each {|translation | promo_object[translation.locale.to_sym] = translation.promo }
    promo_object
  end
end
