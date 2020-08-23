# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :get_current_service # returns an array
  def index
    products = Product.where(services: @current_service)
    category_names_in_use = products.map { |product| product.categories.pluck(:name) }.flatten.uniq
    categories_in_use = Category.where(name: category_names_in_use)
    grouped_collection = Hash[category_names_in_use.map do |category|
                                current_category = categories_in_use.detect { |c| c.name == category }
                                [current_category.name.downcase, {
                                  promo: current_category.promo,
                                  items: serialize_collection(
                                    current_category
                                    .products
                                    .where(services: @current_service)
                                  )
                                }]
                              end
                            ]

    render json: grouped_collection
  end

  private

  def serialize_collection(products)
    ActiveModelSerializers::SerializableResource.new(
      products,
      each_serializer: Products::ShowSerializer,
      adapter: :attributes
    )
  end

  def get_current_service
    @current_service = ServicesService.current
  end
end
