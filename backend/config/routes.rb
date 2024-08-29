Rails.application.routes.draw do
  resources :users, only: [:create]
  # コントローラーの create アクションを使えるようにする
  resources :user_products, only: [:create]
  get 'users/new'
  get 'users/create'
  get 'users/show'
  devise_for :users, controllers: {
    sessions: 'sessions'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # root to: "home#index"
  # Defines the root path route ("/")
  # root "articles#index"
  get '/api/test', to: 'application#test' # ここを追加
  get 'products/search', to: 'products#search'
  get 'rankings', to: 'rankings#index'
  # post 'users', to: 'users#create'
end
