Rails.application.routes.draw do
  root 'root#index'
  get 'download', to: 'root#download'

  resources :sessions, only: [:create, :destroy]

  resources :accounts
  resources :vocabularies,    id: /[^\/]+/

  resources :projects,     id: /[^\/]+/ do
    resources :folders,    id: /[^\/]+/
    resources :files,      id: /[^\/]+/
  end

  # resources :vocabularies
  # resources :terms,      id: /[^\/]+/

  get '/authenticated', to: 'sessions#authenticated'
  get '/logout', to: 'sessions#destroy'

end
