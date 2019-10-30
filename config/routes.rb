Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "homepages#index"

  get "/merchants/current", to: "merchants#current", as: "current_merchant"

  # OAuth support
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#destroy", as: "logout"
  # get "/products/:id/reviews/new", to: "reviews#new", as: "new_review"
  # post "/products/:id/reviews", to: "reviews#create", as: "create_review"

  resources :merchants, except: [:index, :edit, :update]
  resources :products, except: [:destroy] do
    resources :reviews, only: [:new, :create]
  end
  resources :order_items
  resources :orders
  resources :categories, only: [:new, :create]
  # resources :reviews, only: [:index, :new]
end
