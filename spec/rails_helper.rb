require "spec_helper"
ENV["RAILS_ENV"] ||= "test"

require_relative "../config/environment"

abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"
require "telegram/bot/rspec/integration/rails"
require "webmock/rspec"
require "sidekiq/testing"

WebMock.disable_net_connect!(allow_localhost: true)
Dir[Rails.root.join("spec", "support", "**", "*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.use_active_record = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include ActiveSupport::Testing::TimeHelpers

  Sidekiq::Testing.fake!
  config.include FactoryBot::Syntax::Methods

  config.before(:each) do
    fake_store = {}
    fake_redis = Object.new

    fake_redis.define_singleton_method(:get) do |key|
      fake_store[key]
    end

    fake_redis.define_singleton_method(:set) do |key, value|
      fake_store[key] = value
    end

    fake_redis.define_singleton_method(:del) do |key|
      fake_store.delete(key)
    end

    allow(Sidekiq).to receive(:redis).and_yield(fake_redis)
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
