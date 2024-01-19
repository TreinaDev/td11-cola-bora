Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: "home#index"
  resources :projects, only: [:new, :create, :show, :index] do
    get 'my_projects', on: :collection
  end
end
