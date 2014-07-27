Rails.application.routes.draw do
  root 'root#index'
  get 'download', to: 'root#download'

  resources :sessions, only: [:create, :destroy]
  resources :accounts

  resources :projects,     id: /[^\/]+/ do
    resources :folders,    id: /[^\/]+/
    resources :files,      id: /[^\/]+/
  end

  resources :vocabularies, vocabulary_id: /[^\/]+/ do
    resources :terms,      id: /[^\/]+/
  end

  get '/authenticated', to: 'sessions#authenticated'
  get '/logout', to: 'sessions#destroy'

end
