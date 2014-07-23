Rails.application.routes.draw do
  root 'root#index'

  resources :sessions, only: [:create, :destroy]

  resources :accounts

  resources :projects,     :id => /[^\/]+/ do
    resources :folders,    :id => /[^\/]+/
    resources :files,      :id => /[^\/]+/
  end

  # resources :vocabularies
  # resources :terms,      :id => /[^\/]+/

  get '/authenticated', to: 'sessions#authenticated'
  get '/logout', to: 'sessions#destroy'

end
