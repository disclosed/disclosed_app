Rails.application.routes.draw do

  namespace :api, path: "", constraints: { subdomain: "api" }, defaults: { format: :json } do
    resources :contracts, :agencies, only: [:create, :show, :index]
  end
  get 'home/index'
  root 'home#index'
  
end
