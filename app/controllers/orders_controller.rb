# frozen_string_literal: true

class OrdersController < ApplicationController
  def create
    order = user_signed_in? ? current_user.orders.create : Order.create
    NotificationsService.notify_kitchen(order)
    render json: { order: order, message: 'Your order was submitted' }
  end
end
