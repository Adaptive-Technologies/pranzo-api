# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'validate_url/rspec_matcher'
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'stripe_mock'
require 'webmock/rspec'
require 'stripe/rails/testing'
require 'pass_kit_stubs'
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
module JsonHelpers
  def response_json
    JSON.parse(response.body)
  end
end

module ActionCableHelpers
  def channels
    ActionCable.server.pubsub.instance_variable_get(:@channels_data)
  end
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
  config.include Shoulda::Matchers::ActiveRecord, type: :model
  config.include JsonHelpers, type: :request
  config.include ActionCableHelpers, type: :request
  config.before(:each) do
    I18n.locale = :en
    @stripe_test_helper = StripeMock.create_test_helper
    StripeMock.start
    allow(SecureRandom).to receive(:alphanumeric)
      .with(5)
      .and_return('12345')
  end
  config.after(:each) do
    StripeMock.stop
  end
end
