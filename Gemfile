source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "dotenv-rails"
gem "faraday"
gem "interactor"
gem "memery"
gem "pg"
gem "puma", "~> 6.0"
gem "rails", "~> 8.0.3"
gem "sidekiq", "~> 8.0"
gem "telegram-bot"

group :development, :test do
  gem "byebug"
  gem "factory_bot_rails"
  gem "rubocop", require: false
end

group :test do
  gem "rspec-rails", "~> 6.1.0"
  gem "webmock"
end

group :development do
  gem "web-console"
end
