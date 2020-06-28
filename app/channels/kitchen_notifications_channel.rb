# frozen_string_literal: true

class KitchenNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'kitchen_notifications'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
