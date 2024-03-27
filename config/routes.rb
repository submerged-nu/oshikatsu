 

Rails.application.routes.draw do
  resources :users, only: %i[new create show edit update]
  resources :sessions, only: %i[new create destroy]
  resources :posts, only: %i[new index show create destroy] do
    resources :comments, only: %i[create destroy]
  end
  resources :likes, only: %i[create destroy]
  get 'characters/ranking', to: 'characters#ranking'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms_of_service', to: 'static_pages#terms_of_service'
  get 'how_to_use', to: 'static_pages#how_to_use'
  root to: 'posts#index'
end
