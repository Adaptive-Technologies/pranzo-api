class OrdersController < ApplicationController
  def create
    order = Order.create()
    render json: {order: order, message: 'Your order was submitted'}
  end
end
