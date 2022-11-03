# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'active_model_serializers', '~> 0.10.0'
gem 'aws-sdk-s3', require: false
gem 'bootsnap', '>= 1.4.2', require: false
gem 'devise_token_auth'
gem 'geocoder'
gem 'globalize'
gem 'image_processing', '>= 1.12.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'prawn'
gem 'prawn-svg'
gem 'puma', '~> 5.6', '>= 5.6.5'
gem 'rack-cors'
gem 'rails', '~> 7.0', '>= 7.0.4'
gem 'redis', '~> 4.0'
gem 'res_os_ruby'
gem 'rest-client'
gem 'rqrcode'
gem 'stripe-rails'
gem 'validate_url'
gem 'addressable', '~> 2.8', '>= 2.8.1'
gem 'async'
gem 'jmespath', '>= 1.6.1'
gem 'jwt'
gem 'nokogiri', '~> 1.13', '>= 1.13.9'
gem 'rexml', '~> 3.2', '>= 3.2.5'
gem 'valvat'
gem 'mjml-rails'

group :development, :test do
  gem 'clipboard'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'shoulda-callback-matchers'
  gem 'stripe-ruby-mock', '~> 3.1.0.rc2', require: 'stripe_mock'
  gem 'timecop'
  gem 'webmock', '~> 3.14'
  gem 'htmlbeautifier'
end

group :development do
  gem 'guard-rspec', require: false
  gem 'listen', '~> 3.7', '>= 3.7.1'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.1'
end
