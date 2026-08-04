require "sidekiq/web"

if ENV["SIDEKIQ_WEB_USERNAME"].present? && ENV["SIDEKIQ_WEB_PASSWORD"].present?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(username, ENV["SIDEKIQ_WEB_USERNAME"]) &
      ActiveSupport::SecurityUtils.secure_compare(password, ENV["SIDEKIQ_WEB_PASSWORD"])
  end
end

Rails.application.routes.draw do
  telegram_webhook TelegramWebhooksController
  mount Sidekiq::Web => "/sidekiq"

  post "/api/fal/webhook", to: "generator_webhooks#receive"

  namespace :mini_app do
    get "buy_inks", to: "buy_inks#show", as: :buy_inks
    post "buy_inks/packs", to: "buy_inks#packs"
  end
end
