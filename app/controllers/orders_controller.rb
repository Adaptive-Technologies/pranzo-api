# frozen_string_literal: true

class OrdersController < ApplicationController
  def create
    order = user_signed_in? ? current_user.orders.create : Order.create
    if order.persisted?
      add_items(order)
      NotificationsService.notify_kitchen(order)
      render json: {
        order: order, message: 'Your order was submitted'
      }, status: :created
    end
  end

  def index
    orders = Order.all
    render json: orders
  end

  private

  def add_items(order)
    order_params[:items].each do |id|
      order.items.create(product_id: id)
    end
  end

  def order_params
    params.require(:order).permit(items: [])
  end
end
