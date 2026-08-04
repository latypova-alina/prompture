if Rails.env.production? && (ENV["SIDEKIQ_WEB_USERNAME"].blank? || ENV["SIDEKIQ_WEB_PASSWORD"].blank?)
  raise "SIDEKIQ_WEB_USERNAME and SIDEKIQ_WEB_PASSWORD must be set in production to protect the Sidekiq web UI"
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV["REDIS_URL"],
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV["REDIS_URL"],
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
end
