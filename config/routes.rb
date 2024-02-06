Rails.application.routes.draw do
  get 'posts/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :posts, only: [:index]
  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destory]
end
