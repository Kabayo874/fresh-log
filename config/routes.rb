Rails.application.routes.draw do
 
  get 'users/show'
  get 'users/edit'
  devise_for :users
  root to: "homes#top"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'homes/about' => 'homes#about', as: 'about'

  resources :users, only: [:show, :edit, :update, :groups] do
    member do
      get :groups
    end
  end
  resources :items, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    resources :item_posts, only: [:new, :create, :edit, :update, :destroy]
  end
  resources :groups, only: [:new, :create, :show, :edit] do
    resources :group_members, only: [:create, :destroy]
  end

end