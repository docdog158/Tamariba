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
    get 'customers/my_page', to: 'customers#show'
    get 'customers/information/edit', to: 'customers#edit'
    patch 'customers/information', to: 'customers#update'
    get 'customers/unsubscribe', to: 'customers#unsubscribe'
    patch 'customers/withdraw', to: 'customers#withdraw'
    resources :posts do

    resources :comments, only: [:create, :destroy]
    resource :favorite, only: [:create, :destroy]
    end
  end

  #guest機能

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end