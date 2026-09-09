require "sidekiq/web"

Rails.application.routes.draw do
  telegram_webhook TelegramWebhooksController

  constraints subdomain: "admin" do
    root to: "admin#index"
    get "/blazer", to: redirect("/blazer/dashboards/1"), as: :admin_blazer_root
    mount Blazer::Engine, at: "/blazer"
    mount Sidekiq::Web => "/sidekiq"
  end

  post "/api/fal/webhook", to: "generator_webhooks#receive"

  namespace :mini_app do
    get "buy_stones", to: "buy_stones#show", as: :buy_stones
    post "buy_stones/packs", to: "buy_stones#packs"
  end
end
