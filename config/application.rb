# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'

Dir[File.join(__dir__, 'patches', '*.rb')].each { |file| require file }

Bundler.require(*Rails.groups)

module BocadoApi
  class Application < Rails::Application
    config.eager_load_paths += %W[#{config.root}/lib]
    config.load_defaults 6.1
    config.api_only = true
    config.i18n.default_locale = :en
    config.i18n.available_locales = %i[en sv]
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
                 headers: :any,
                 methods: %i[get post put delete],
                 expose: %w[access-token expiry token-type uid client],
                 max_age: 0
      end
    end
    config.active_record.legacy_connection_handling = false
    config.session_store :cookie_store, key: '_interslice_session'
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use config.session_store, config.session_options
    config.i18n.available_locales = %i[en sv]
    config.stripe.secret_key = if !ActiveModel::Type::Boolean.new.cast(ENV['PRE_PRODUCTION']) && Rails.env.production?
                                 Rails.application.credentials.stripe[:sk_live_key]
                               else
                                 Rails.application.credentials.stripe[:sk_test_key]
                               end
  end
end
