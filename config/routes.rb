Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  root to: "home#index"

  resources :profiles, only: [:edit, :update, :show]
  resources :projects, only: [:new, :create, :show]
end
