Rails.application.routes.draw do
  root 'root#index'
  get 'download', to: 'root#download'

  resources :accounts

  post '/register', to: 'accounts#create'
  post '/sign_in', to: 'sessions#create'
  post '/sign_out', to: 'sessions#destroy'

  resources :projects,     id: /[^\/]+/ do
    resources :folders,    id: /[^\/]+/
    resources :files,      id: /[^\/]+/
  end

  resources :vocabularies, vocabulary_id: /[^\/]+/ do
    resources :terms,      id: /[^\/]+/
  end
end
