Rails.application.routes.draw do
  resources :users, only: [:new, :create, :show, :edit, :update]
  resources :sessions, only: [:new, :create, :destroy]
  resources :posts, only: [:new, :index, :show, :create, :destroy] do
    resources :comments, only: [:create, :destroy]
  end
  resources :likes, only: [:create, :destroy]
  root to: 'posts#index'
end
