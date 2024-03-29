Rails.application.routes.draw do
  devise_for :users
  root 'users#index'
  resources :users, only: [:index, :show] do
    resources :posts, only: [:index, :show, :new, :create, :destroy] do
      resources :comments, only: [:new, :create, :destroy]
      resources :likes, only: [:create]
    end
  end
  # API endpoints
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :create, :update, :destroy, :show] do
        resources :posts, only: [:index, :create, :update, :destroy, :show] do
          resources :comments, only: [:index, :show]
          resources :likes, only: [:index, :show]
        end
      end
    end
  end
end
