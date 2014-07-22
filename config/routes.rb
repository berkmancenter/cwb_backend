Rails.application.routes.draw do
  root 'root#index'

  resources :sessions, only: [:create, :destroy]
  resources :accounts
  get '/authenticated', to: 'sessions#authenticated'
  get '/logout', to: 'sessions#destroy'
end
