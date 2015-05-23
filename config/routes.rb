Rails.application.routes.draw do
  root 'artists#index'
  get 'artists', to: 'artists#index'
end
