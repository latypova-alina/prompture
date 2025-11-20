require "sidekiq/web"

Rails.application.routes.draw do
  telegram_webhook TelegramWebhooksController
  mount Sidekiq::Web => "/sidekiq"

  post "/freepik/webhook", to: "freepik_webhooks#receive"
end
