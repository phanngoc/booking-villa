Rails.application.routes.draw do
  get "villas/index"
  get "villas/show"
  namespace :admin do
    get "users/index"
    get "users/show"
  end
  devise_for :users

  # Routes cho quản lý user
  resources :users

  # Routes cho villa
  resources :villas, only: [ :index, :show ] do
    resources :bookings
  end

  # Routes cho booking
  resources :bookings

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "villas#index"

  get "my-bookings", to: "bookings#my_bookings", as: :my_bookings
end
