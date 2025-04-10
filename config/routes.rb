Rails.application.routes.draw do
 
  devise_for :users
  root to: "homes#top"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'homes/about' => 'homes#about', as: 'about'

  resources :items, only: [:new, :create, :index, :show, :edit]
  resources :item_posts, only: [:new]
  resources :groups, only: [:new, :create, :index, :show]

end