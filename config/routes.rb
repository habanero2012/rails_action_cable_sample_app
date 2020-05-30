Rails.application.routes.draw do
  root 'static_pages#home'
  get 'static_pages/home', as: :home
  get 'static_pages/help', as: :help
  get 'static_pages/about', as: :about
  get 'static_pages/contact', as: :contact
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: %i[edit]
  resources :password_resets, only: %i[new create edit update]
  resources :microposts, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
end
