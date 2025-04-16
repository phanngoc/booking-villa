require "sidekiq/web"

Rails.application.routes.draw do
  get "villas/index"
  get "villas/show"
  namespace :admin do
    resources :notifications do
      collection do
        get :count_unread
        post :mark_all_as_read
      end
      member do
        post :mark_as_read
      end
    end
    resources :users
    resources :filter_fields
    resources :bookings

    # Routes cho quản lý metafields
    resources :villas do
      resources :metafields, controller: "villa_metafields"
    end

    resources :chats, only: [ :index, :show ] do
      collection do
        post :receive_message
      end
    end

    # Routes cho admin đăng nhập
    devise_scope :user do
      get "login", to: "sessions#new", as: :new_session
      post "login", to: "sessions#create", as: :session
      delete "logout", to: "sessions#destroy", as: :destroy_session
    end
  end

  # Sử dụng controller tùy chỉnh cho sessions và omniauth callbacks
  devise_for :users, controllers: {
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  # Routes cho quản lý user
  resources :users

  # Routes cho villa
  resources :villas, only: [ :index, :show ] do
    resources :bookings
  end

  # Routes cho booking
  resources :bookings do
    member do
      post :cancel
    end
    resource :payment, only: [ :show, :update ] do
      get :choose_payment_method
      get :sol_payment
      post :verify_sol_payment
      get :bank_transfer
    end
  end

  # Routes cho chat của người dùng
  resources :chats, only: [ :index, :show ] do
    collection do
      post :create_message
    end
  end

  # Routes cho admin chat
  namespace :admin do
    resources :chats, only: [ :index, :show ] do
      member do
        patch :close
        patch :reopen
      end
      collection do
        get :chat_console
      end
    end
  end

  # Sidekiq Web UI
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  # Mount ActionCable cho WebSocket
  mount ActionCable.server => "/cable"

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
  get "contact", to: "home#contact", as: :contact
end
