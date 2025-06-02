Rails.application.routes.draw do

  scope module: :public do
    devise_for :users
    root to: "homes#top"
    get 'search', to: 'searches#search', as: 'search'
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

    get 'homes/about' => 'homes#about', as: 'about'

    # ユーザー画面
    resources :users, only: [:show, :edit, :update, :groups] do
      member do
        get :groups
        patch :withdraw
      end
    end
    resources :items, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
      resources :item_posts, only: [:new, :create, :edit, :update, :destroy]
      resources :comments, only: [:create, :destroy]
    end
    resources :groups, only: [:new, :create, :show, :edit, :update, :destroy] do
      resources :group_members, only: [:create, :destroy]
      resources :items, only: [:new, :create]

    end
  end

  devise_for :admin, skip: [:registrations, :password], controllers: {
    sessions: 'admin/sessions'
  }


  # 管理者画面
  namespace :admin do
    get 'dashboards', to: 'dashboards#index'
    resources :users, only: [:index, :destroy, :show] do
      member do
        get :groups
      end
    end

    resources :items, only: [:index, :show, :destroy] do
      resources :item_posts, only: [:destroy]
      resources :comments, only: [:destroy]
    end
    resources :groups, only: [:index, :show, :destroy] do
      resources :group_members, only: [:destroy]
    end
  end

end