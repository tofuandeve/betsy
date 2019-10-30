Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "homepages#index"
  
  get "/merchants/current", to: "merchants#current", as: "current_merchant"
  
  # OAuth support
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#destroy", as: "logout"
  
  post "/products/:id/addtocart", to: "order_items#create", as: "add_to_cart"
  patch "/products/:id/placeorder", to: "orders#place_order", as: "place_order"

  resources :merchants, except: [:index, :edit, :update]
  resources :products, except: [:destroy]
  resources :order_items, except: [:show, :index]
  resources :orders
  resources :categories, only: [:new, :create]
end
