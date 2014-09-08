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
    resources :vocabularies, id: /[^\/]*/ do
      resources :terms,      id: /[^\/]*/
    end
    post '/files/:id', to: 'files#destroy', id: /[^\/]*/
    put '/star_file/:id', to: 'files#mark_starred', id: /[^\/]*/
    put '/unstar_file/:id', to: 'files#unmark_starred', id: /[^\/]*/
  end

end
