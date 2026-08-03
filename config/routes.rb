require "sidekiq/web"

Rails.application.routes.draw do
  telegram_webhook TelegramWebhooksController
  mount Sidekiq::Web => "/sidekiq"

  post "/api/fal/webhook", to: "generator_webhooks#receive"

  namespace :mini_app do
    get "buy_credits", to: "buy_credits#show", as: :buy_credits
    post "buy_credits/packs", to: "buy_credits#packs"
  end
end
