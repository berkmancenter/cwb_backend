Rails.application.routes.draw do
  root 'root#index'
  get 'download', to: 'root#download'

  resources :accounts, only: [:index]

  post '/register', to: 'accounts#create'
  post '/sign_in', to: 'sessions#sign_in'
  get '/sign_out', to: 'sessions#sign_out'

  resources :projects,     id: /[^\/]+/ do
    resources :folders,    id: /[^\/]+/
    resources :files,      id: /[^\/]+/
  end

  resources :vocabularies, vocabulary_id: /[^\/]+/ do
    resources :terms,      id: /[^\/]+/
  end
end
