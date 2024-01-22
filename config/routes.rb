Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  root to: "home#index"
  resources :profiles, only: %i[edit]
  resources :projects, only: [:new, :create, :show] do
    resources :tasks, only: [:index, :new, :create]
  end

  resources :tasks, only: [:show, :edit, :update,] do
    member do
      post 'start'
      post 'finish'
      post 'cancel'
    end
  end
end
