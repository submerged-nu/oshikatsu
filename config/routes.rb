Rails.application.routes.draw do
  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]
  resources :posts, only: [:new, :index, :show, :create, :destroy]
end
