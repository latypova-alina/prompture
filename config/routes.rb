require "sidekiq/web"

Rails.application.routes.draw do
  telegram_webhook TelegramWebhooksController
  mount Sidekiq::Web => "/sidekiq"

  post "/api/fal/webhook", to: "generator_webhooks#receive"
end
