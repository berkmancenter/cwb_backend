Rails.application.routes.draw do
  root 'root#index'
  get 'download', to: 'root#download'

  resources :accounts

  post '/register', to: 'accounts#create'
  post '/sessions', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resources :projects,     id: /[^\/]+/ do
    resources :folders,    id: /[^\/]+/
    resources :files,      id: /[^\/]+/
  end

  resources :vocabularies, vocabulary_id: /[^\/]+/
  resources :terms,      id: /[^\/]+/
end
