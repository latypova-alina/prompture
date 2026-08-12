require "sidekiq/web"

if ENV["SIDEKIQ_WEB_USERNAME"].present? && ENV["SIDEKIQ_WEB_PASSWORD"].present?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(username, ENV["SIDEKIQ_WEB_USERNAME"]) &
      ActiveSupport::SecurityUtils.secure_compare(password, ENV["SIDEKIQ_WEB_PASSWORD"])
  end
end

if ENV["BLAZER_USERNAME"].present? && ENV["BLAZER_PASSWORD"].present?
  begin
    Blazer::Engine.middleware.use Rack::Auth::Basic do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(username, ENV["BLAZER_USERNAME"]) &
        ActiveSupport::SecurityUtils.secure_compare(password, ENV["BLAZER_PASSWORD"])
    end
  rescue FrozenError
    # Blazer::Engine freezes its middleware stack after the first build (unlike Sidekiq::Web),
    # so routes.rb reloading in development re-runs this and hits an already-applied stack.
  end
end

Rails.application.routes.draw do
  telegram_webhook TelegramWebhooksController
  mount Sidekiq::Web => "/sidekiq"
  get "/blazer", to: redirect("/blazer/dashboards/1"), as: :blazer_root
  mount Blazer::Engine, at: "/blazer"

  post "/api/fal/webhook", to: "generator_webhooks#receive"

  namespace :mini_app do
    get "buy_stones", to: "buy_stones#show", as: :buy_stones
    post "buy_stones/packs", to: "buy_stones#packs"
  end
end
