Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "homepages#index"

  resources :merchants, except: [:index, :edit, :update]
  resources :products, except: [:destroy]

  get "/merchants/current", to: "merchants#current", as: "current_merchant"

  # OAuth support
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#destroy", as: "logout"

  resources :orders
  resources :categories
end
