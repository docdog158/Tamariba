Rails.application.routes.draw do

  devise_for :admin, controllers: {
    sessions: "admin/sessions"
  }

  devise_for :customers, controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  namespace :admin do
    root to: "homes#top"
    resources :customers, only: [:index, :show, :edit, :update]
    resources :posts do
      resources :comments, only: [:destroy]
    end
    get "search" => "searches#search"
  end


  scope module: :public do
    root :to => 'homes#top'
    get "search" => "searches#search"
    get 'customers/unsubscribe', to: 'customers#unsubscribe'
    patch 'customers/withdraw', to: 'customers#withdraw'
    resources :customers,only: [:show, :edit, :update, :index]do
    #フォロー機能
      resource :relationships, only: [:create, :destroy]
      get "followings" => "relationships#followings", as: "followings"
      get "followers" => "relationships#followers", as: "followers"
      member do
        # いいねした一覧
        get :liked_posts
      end
    end
    resources :post_pets do
      resources :post_comments, only: [:create, :destroy]
      resource :favorite, only: [:create, :destroy]
    end
  end

  #guest機能

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end