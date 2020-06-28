# frozen_string_literal: true

module NotificationsService
  def self.notify_kitchen(order)
    ActionCable
      .server
      .broadcast(
        'kitchen_notifications',
        data: { message: "#{order.created_at.to_s(:time)}: incoming order" }
      )
  end
end
