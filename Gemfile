source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'active_model_serializers'
gem 'aws-sdk-s3', require: false
gem 'bootsnap', '>= 1.4.2', require: false
gem 'cocoon'
gem 'devise'
gem 'devise-i18n'
gem 'devise-i18n-views'
gem 'dotenv-rails'
gem 'enum_help'
gem 'fcm'
gem 'image_processing', '~> 1.2'
gem 'jbuilder', '~> 2.7'
gem 'jwt'
gem 'kaminari'
gem 'lograge'
gem 'mysql2', '>= 0.4.4'
gem 'puma', '~> 3.11'
gem 'rack-cors'
gem 'rails', '~> 6.0.2'
gem 'rails-i18n'
gem 'rollbar'
gem 'sass-rails', '~> 5'
gem 'sidekiq'
gem 'simple_form'
gem 'slack-notifier'
gem 'slim'
gem 'stripe'
gem 'turbolinks', '~> 5'
gem 'twilio-ruby'
gem 'unicorn'
gem 'webpacker', '~> 4.0'

group :development, :test do
  gem 'brakeman'
  gem 'byebug', platforms: %w[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'pry-stack_explorer'
  gem 'rspec-rails', '~> 4.0.1'
end

group :development do
  gem 'capistrano'
  gem 'capistrano3-nginx', '~> 2.0'
  gem 'capistrano3-unicorn'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-yarn'
  gem 'letter_opener'
  gem 'listen', '~> 3.4.1'
  gem 'rails-erd'
  gem 'rubocop'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: %w[mingw mswin x64_mingw jruby]
