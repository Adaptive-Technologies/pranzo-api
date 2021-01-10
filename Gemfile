# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'image_processing', '~> 1.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'rack-cors'
gem 'rails', '~> 6.0.2', '>= 6.0.2.2'
gem 'redis', '~> 4.0'
gem 'devise_token_auth'
gem 'active_model_serializers', '~> 0.10.0'
gem 'validate_url'
gem 'rest-client'
gem 'res_os_ruby'
gem 'rqrcode'
gem "aws-sdk-s3", require: false
gem 'prawn-svg'
gem 'prawn'
gem 'stripe-rails'
gem 'geocoder'


group :development, :test do
  gem 'factory_bot_rails'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'faker'
  gem 'timecop'
  gem 'pdf-inspector', require: "pdf/inspector"
    gem 'stripe-ruby-mock', '~> 2.5.8', require: 'stripe_mock'

end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'guard-rspec', require: false
end
