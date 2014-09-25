Rails.application.routes.draw do

  root 'root#index'

  resources :accounts
  resources :profiles

  post '/register', to: 'accounts#create'
  post '/sessions', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/authenticated', to: 'sessions#auth'

  resources :projects,     id: /[^\/]*/ do
    get 'download', to: 'projects#download'
    resources :folders,    id: /[^\/]*/
    resources :files, except: :destroy,     id: /[^\/]*/
    put '/tag_files', to: 'files#tag_files'
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
