Rails.application.routes.draw do

  namespace :api, path: "", constraints: { subdomain: "api" }, defaults: { format: :json } do
    resources :contracts, :agencies, only: [:create, :show, :index]
  end
  get '/home/download', to: 'home#download', as: 'report_download'
  get 'home/index'
  resources :watchers, only: [:create]
  root 'home#index'
  
end
