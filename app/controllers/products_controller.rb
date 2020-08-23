# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :get_current_service # returns an array
  def index
    products = Product.where(services: @current_service)
    render json: { products: products }
  end

  private

  def get_current_service
    @current_service = ServicesService.current
  end
end
