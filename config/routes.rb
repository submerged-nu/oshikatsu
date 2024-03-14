Rails.application.routes.draw do
  resources :users, only: [:new, :create, :show, :edit, :update]
  resources :sessions, only: [:new, :create, :destroy]
  resources :posts, only: [:new, :index, :show, :create, :destroy] do
    resources :comments, only: [:create, :destroy]
  end
  resources :likes, only: [:create, :destroy]
  get 'characters/ranking', to: 'characters#ranking'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms_of_service', to: 'static_pages#terms_of_service'
  root to: 'posts#index'
end
