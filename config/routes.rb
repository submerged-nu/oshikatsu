 Rails.application.routes.draw do
   get 'oauths/oauth'
  mount ActionCable.server => '/cable'
  resources :users, only: %i[new create show edit update]
  resources :sessions, only: %i[new create destroy]
  resources :posts, only: %i[new index show create destroy] do
    resources :comments, only: %i[create]
  end
  resources :likes, only: %i[create destroy]
  get 'oauths/oauth', to: 'oauths#oauth'
  get 'oauths/callback', to: 'oauths#callback'
  get 'characters/ranking', to: 'characters#ranking'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms_of_service', to: 'static_pages#terms_of_service'
  get 'how_to_use', to: 'static_pages#how_to_use'
  get 'top_page', to: 'static_pages#top_page'
  get 'characters/auto_complete', to: 'characters#auto_complete'
  get 'notifications', to: 'notifications#index'
  post 'notifications/mark_as_read', to: 'notifications#mark_as_read'
  get 'recommends', to: 'recommends#index'
  root to: 'posts#index'
end
