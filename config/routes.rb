Rails.application.routes.draw do
  root 'root#index'

  resources :sessions, only: [:create, :destroy]
  get '/authenticated', to: 'sessions#authenticated'
  get '/logout', to: 'sessions#destroy'
end
