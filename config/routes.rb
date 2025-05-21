Rails.application.routes.draw do
 
  namespace :admin do
    get 'user_items/index'
  end
  get 'users/show'
  get 'users/edit'

  scope module: :public do
    devise_for :users
    root to: "homes#top"
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

    get 'homes/about' => 'homes#about', as: 'about'

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
    resources :groups, only: [:new, :create, :show, :edit, :update] do
      resources :group_members, only: [:create, :destroy]
      resources :items, only: [:new, :create]
    end
  end

  devise_for :admin, skip: [:registrations, :password], controllers: {
    sessions: 'admin/sessions'
  }

  namespace :admin do
    get 'dashboards', to: 'dashboards#index'
    resources :users, only: [:index, :destroy]
      resource :items, only: [:index], controller: 'user_items'
  end

end