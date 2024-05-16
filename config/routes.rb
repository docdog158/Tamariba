Rails.application.routes.draw do

  devise_for :admin, controllers: {
    sessions: "admin/sessions"
  }

  devise_for :customers, controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions',
    passwords: 'users/passwords'
  }
  namespace :admin do
    root to: "homes#top"
    get "search" => "searches#search"
    get "search_tag" => "post_pets#search_tag", as: "search_tag"
    resources :tags, only: [:index, :destroy]
    resources :customers, only: [:index, :show, :destroy]
    resources :post_pets, only: [:index, :show, :destroy] do
      resources :comments, only: [:destroy]
    end
  end


  scope module: :public do
    root :to => 'homes#top'
    get "about" => "homes#about"
    get "search" => "searches#search"
    get "search_tag" => "post_pets#search_tag", as: "search_tag"
    get 'ranking' => 'post_pets#ranking'
    resources :notifications, only: [:update, :index]
    resources :customers,only: [:show, :edit, :update, :destroy]do
      get 'unsubscribe', to: 'customers#unsubscribe'
      resource :relationships, only: [:create, :destroy]
      get "followings" => "relationships#followings", as: "followings"
      get "followers" => "relationships#followers", as: "followers"
      member do
        get :liked_posts
      end
    end

  devise_scope :customer do
    post 'public/guest_sign_in', to: 'sessions#guest_sign_in'
  end

    resources :messages, only: [:create]
    resources :rooms, only: [:create, :show]

    resources :post_pets do
      resources :post_comments, only: [:create, :destroy]
      resource :favorite, only: [:create, :destroy]
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end