# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :get_current_service
  def index
    # '&&' overlap (have elements in common) is documented at https://www.postgresql.org/docs/current/functions-array.html
    query = "services && '{#{@current_services}}'"
    products = Product.where(query)
    category_names_in_use = products.map { |product| product.categories.pluck(:name) }.flatten.uniq
    categories_in_use = Category.where(name: category_names_in_use)
    grouped_collection = Hash[category_names_in_use.map do |category|
                                current_category = categories_in_use.detect { |c| c.name == category }
                                [current_category.name.downcase, {
                                  promo: current_category.promo,
                                  items: serialize_collection(
                                    current_category
                                    .products
                                    .where(query)
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
    @current_services = ServicesService.current.join(', ')
  end
end
