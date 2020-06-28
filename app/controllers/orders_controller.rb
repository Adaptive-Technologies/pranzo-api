class OrdersController < ApplicationController
  def create
    order = Order.create()
    NotificationsService.notify_kitchen(order)
    render json: {order: order, message: 'Your order was submitted'}
  end
end
