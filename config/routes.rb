Rails.application.routes.draw do
  root "home#index"

  namespace :customer do
    get "/", to: "home#index", as: :root
    resources :orders, only: [ :create ]
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    get "register", to: "registrations#new"
    post "register", to: "registrations#create"
    delete "logout", to: "sessions#destroy"
  end

  namespace :artist do
    get "sessions/new"
    get "products/index"
    get "products/show"
    get "products/new"
    get "products/edit"
    get "register", to: "registrations#new"
    post "register", to: "registrations#create"
  end
  namespace :admin do
    get "commissions/index"
    get "commissions/show"
    get "commissions/edit"
    get "users/index"
    get "users/show"
    get "orders/index"
    get "orders/show"
    get "orders/edit"
    resources :products
    resources :categories
    resources :orders, only: [ :index, :show, :edit, :update ]
    resources :commissions, only: [ :index, :show, :edit, :update ]
    resources :users, only: [ :index, :show ]

    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    get "register", to: "registrations#new"
    post "register", to: "registrations#create"
    delete "logout", to: "sessions#destroy"
  end

  namespace :artist do
    resources :products
    resources :categories, only: [ :index, :new, :create ]

    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
  end

  namespace :api do
    namespace :v1 do
      post "register", to: "auth#register"
      post "login", to: "auth#login"

      resources :products, only: [ :index, :show ]
      resources :orders, only: [ :index, :show, :create ]
      resources :commissions, only: [ :index, :show, :create ]

      get "profile", to: "profile#show"
    end
  end
end
