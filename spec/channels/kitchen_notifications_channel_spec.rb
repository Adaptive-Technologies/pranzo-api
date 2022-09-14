# frozen_string_literal: true

RSpec.describe KitchenNotificationsChannel, type: :channel do
  describe 'subscription' do
    before do
      subscribe
    end

    it {
      expect(subscription).to be_confirmed
    }

    it {
      expect(subscription).to have_stream_from('kitchen_notifications')
    }

    it 'is expected to broadcast to "kitchen_notifications"' do
      expect do
        ActionCable.server.broadcast('kitchen_notifications', { data: { message: 'incoming order' } })
      end
        .to have_broadcasted_to('kitchen_notifications')
        .with({ data: { message: 'incoming order' } })
    end
  end
end
