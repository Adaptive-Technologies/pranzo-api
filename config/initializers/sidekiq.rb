require 'sidekiq/web'
require 'sidekiq/cron/web'

if Rails.env.production?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    # Use environment variables or another secure approach to set credentials
    username == ENV['SIDEKIQ_USERNAME'] && password == ENV['SIDEKIQ_PASSWORD']
  end
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

module Sidekiq
  module WebHelpers
    def locale
      'sv'
    end
  end
end
