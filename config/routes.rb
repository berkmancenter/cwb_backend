Rails.application.routes.draw do

  root 'root#index'
  get 'download', to: 'root#download'

  resources :accounts
  resources :profiles

  post '/register', to: 'accounts#create'
  post '/sessions', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/authenticated', to: 'sessions#auth'

  resources :projects,     id: /[^\/]*/ do
    resources :folders,    id: /[^\/]*/
    resources :files, except: :destroy,     id: /[^\/]*/ do
      put '/tag_file', to: 'files#tag_file'
      delete '/untag_file', to: 'files#untag_file'
    end
    put '/star_file/:id', to: 'files#mark_starred', id: /[^\/]*/
    put '/unstar_file/:id', to: 'files#unmark_starred', id: /[^\/]*/
    put '/star_files', to: 'files#mark_starred_multiple'
    put '/unstar_files', to: 'files#unmark_starred_multiple'
    resources :vocabularies, id: /[^\/]*/ do
      resources :terms,      id: /[^\/]*/
    end
    post '/files/:id', to: 'files#destroy', id: /[^\/]*/
  end

end
