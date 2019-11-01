Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "homepages#index"
  
  get "/merchants/current", to: "merchants#current", as: "current_merchant"
  
  # OAuth support
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#destroy", as: "logout"
  
  resources :merchants, except: [:index, :edit, :update]
  resources :products, except: [:destroy] do
    resources :reviews, only: [:new, :create]
  end
  
  post "/products/:id/addtocart", to: "order_items#create", as: "add_to_cart"
  patch "/products/:id/retire", to: "products#retire", as: "retire"
  patch "/orders/:id/placeorder", to: "orders#place_order", as: "place_order"
  patch "/order_items/:id/mark_shipped", to: "order_items#mark_shipped", as: "mark_shipped"
  patch "/orders/:id/cancel", to: "orders#cancel", as: "cancel"
  
  resources :merchants, except: [:index, :edit, :update] do
    resources :products, only: [:index]
  end
  
  get "/orders/:id/confirmation", to: "orders#confirmation", as: "confirmation"
  get "/orders/:id/buyer_info", to: "orders#buyer_info", as: "buyer_info"
  
  resources :products, except: [:destroy]
  resources :order_items, except: [:show, :index]
  resources :orders, except: [:index]
  
  resources :categories, only: [:new, :create] do
    resources :products, only: [:index]
  end
end
