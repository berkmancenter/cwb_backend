Rails.application.routes.draw do
  root 'root#index'

  resources :sessions, only: [:create, :destroy]
  get '/logout', to: 'sessions#destroy'
end
