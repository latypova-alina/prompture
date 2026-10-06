require "sidekiq/web"

Rails.application.routes.draw do
  telegram_webhook TelegramWebhooksController

  constraints subdomain: "admin" do
    root to: "admin#index"
    resources :users, controller: "admin/users", only: %i[index show] do
      resources :command_requests, controller: "admin/command_requests", only: :index
      resources :button_requests, controller: "admin/button_requests", only: :index
    end
    resources :requests, controller: "admin/requests", only: :index
    resources :command_requests, controller: "admin/command_requests", only: :index
    resources :button_requests, controller: "admin/button_requests", only: :index
    get "/command_requests/:type/:id", to: "admin/command_requests#show", as: :command_request
    get "/button_requests/:type/:id", to: "admin/button_requests#show", as: :button_request
    get "/blazer", to: redirect("/blazer/dashboards/1"), as: :admin_blazer_root
    mount Blazer::Engine, at: "/blazer"
    mount Sidekiq::Web => "/sidekiq"
  end

  post "/api/fal/webhook", to: "generator_webhooks#receive"

  namespace :mini_app do
    get "buy_stones", to: "buy_stones#show", as: :buy_stones
    post "buy_stones/packs", to: "buy_stones#packs"
    get "review", to: "reviews#show", as: :review
    post "review/survey", to: "reviews#survey", as: :review_survey
    post "review", to: "reviews#create"
  end
end
