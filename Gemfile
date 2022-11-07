# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'active_model_serializers', '~> 0.10.0'
gem 'addressable', '~> 2.8', '>= 2.8.1'
gem 'async'
gem 'aws-sdk-s3', require: false
gem 'bootsnap', '>= 1.4.2', require: false
gem 'devise_token_auth'
gem 'geocoder'
gem 'glib2', '~> 4.0', '>= 4.0.3'
gem 'globalize'
gem 'image_processing', '>= 1.12.2'
gem 'jmespath', '>= 1.6.1'
gem 'jwt'
gem 'mjml-rails'
gem 'nokogiri', '~> 1.13', '>= 1.13.9'
gem 'pg', '>= 0.18', '< 2.0'
gem 'prawn'
gem 'prawn-svg'
gem 'puma', '~> 5.6', '>= 5.6.5'
gem 'rack-cors'
gem 'rails', '~> 7.0', '>= 7.0.4'
gem 'redis', '~> 4.0'
gem 'res_os_ruby'
gem 'rest-client'
gem 'rexml', '~> 3.2', '>= 3.2.5'
gem 'rqrcode'
gem 'rsvg2', '~> 4.0', '>= 4.0.3'
gem 'stripe-rails'
gem 'validate_url'
gem 'valvat'

group :development, :test do
  gem 'capybara-email', '~> 3.0', '>= 3.0.2'
  gem 'clipboard'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'htmlbeautifier'
  gem 'launchy'
  gem 'letter_opener'
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'shoulda-callback-matchers'
  gem 'shoulda-matchers'
  gem 'stripe-ruby-mock', '~> 3.1.0.rc2', require: 'stripe_mock'
  gem 'timecop'
  gem 'webmock', '~> 3.14'
end

group :development do
  gem 'guard-rspec', require: false
  gem 'listen', '~> 3.7', '>= 3.7.1'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.1'
end
