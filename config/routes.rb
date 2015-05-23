Rails.application.routes.draw do
  root 'artists#index'
  get 'artists', to: 'artists#index'
  get 'artists/new', to: 'artists#new'
  post 'artists', to: 'artists#create'
end
