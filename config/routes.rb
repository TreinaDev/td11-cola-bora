Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: "home#index"

  resources :projects, only: [:show] do
    resources :tasks, only: [:new, :create, :show]
  end
end
