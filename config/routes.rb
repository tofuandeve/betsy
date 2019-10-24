Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root to: "merchants#index"
  get "/auth/:provider", to: "merchants#create", as: "auth_callback"

  # resources :merchants, except: [:create]
end
