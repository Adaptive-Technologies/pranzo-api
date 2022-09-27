# frozen_string_literal: true

module NotificationsService
  def self.notify_kitchen(order)
    message = "#{order.created_at.to_fs(:time)}: incoming order"
    message = message.dup.concat(" from #{order.user.name}") if order.user
    ActionCable.server.broadcast('kitchen_notifications', { data: { message: message } })
  end
end
