source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

gem 'rails'

gem 'bootsnap', require: false
gem 'bugsnag'
gem 'dotenv-rails'
gem 'google-apis-sheets_v4'
gem 'google-cloud-language'
gem 'paper_trail'
gem 'pg'
gem 'puma'
gem 'remote_syslog_logger'
gem 'rollbar'
gem 'twitter'

group :development, :test do
  gem 'byebug'
  gem 'factory_bot_rails'
  gem 'pry-rails'
  gem 'rspec-rails'
end

group :development do
  gem 'listen'
  gem 'rubocop-rails'
  gem 'spring'
end

group :test do
  gem 'rspec_junit_formatter'
end
