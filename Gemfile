source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'
gem 'rails', '~> 7.1.2'

gem 'active_storage_validations'
gem 'bootsnap', require: false
gem 'cpf_cnpj', '~> 0.5.0'
gem 'cssbundling-rails'
gem 'devise'
gem 'faraday'
gem 'jbuilder'
gem 'jsbundling-rails'
gem 'puma', '~> 6.0'
gem 'rack-cors'
gem 'simple_calendar'
gem 'sprockets-rails'
gem 'sqlite3', '~> 1.4'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'cuprite'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'simplecov', require: false
end
