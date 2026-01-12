require "sidekiq/web"

Rails.application.routes.draw do
  telegram_webhook TelegramWebhooksController
  mount Sidekiq::Web => "/sidekiq"

  post "/prompt_to_image_webhook", to: "prompt_to_image_webhooks#receive"
end
