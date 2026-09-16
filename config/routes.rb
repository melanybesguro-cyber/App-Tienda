Rails.application.routes.draw do
  namespace :admin do
    get "orders/index"
    get "orders/show"
    get "orders/edit"
    resources :products
    resources :categories
    resources :orders, only: [:index, :show, :edit, :update]

    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
  end
end