Rails.application.routes.draw do
  require "sidekiq/web"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :invoices

  mount Sidekiq::Web => "/sidekiq" # access it at http://localhost:3000/sidekiq
end
