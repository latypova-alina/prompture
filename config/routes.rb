require "sidekiq/web"

Rails.application.routes.draw do
  telegram_webhook TelegramWebhooksController
  mount Sidekiq::Web => "/sidekiq"

  post "/api/fal/webhook", to: "generator_webhooks#receive"

  namespace :mini_app do
    get "buy_inks", to: "buy_inks#show", as: :buy_inks
    post "buy_inks/packs", to: "buy_inks#packs"
  end
end
