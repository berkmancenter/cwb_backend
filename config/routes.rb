Rails.application.routes.draw do
  root 'root#index'
  get 'download', to: 'root#download'

  resources :accounts

  post '/register', to: 'accounts#create'
  post '/sessions', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/authenticated', to: 'sessions#auth'

  resources :projects,     id: /[^\/]*/ do
    resources :folders,    id: /[^\/]*/
    resources :files, except: :destroy,     id: /[^\/]*/
    post '/files/:id', to: 'files#destroy', id: /[^\/]*/
    get '/star_file/:id', to: 'files#mark_starred', id: /[^\/]*/
    get '/unstar_file/:id', to: 'files#unmark_starred', id: /[^\/]*/
  end

  resources :vocabularies, vocabulary_id: /[^\/]*/
  resources :terms,      id: /[^\/]*/
end
