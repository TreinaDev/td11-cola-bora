Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  root to: "home#index"

  resources :profiles, only: %i[edit update show]
  resources :projects, only: %i[new create show index edit destroy] do
    resources :tasks, only: %i[index new create]
    resources :documents, only: %i[index new create]
    get 'my_projects', on: :collection
  end

  resources :tasks, only: %i[show edit update] do
    member do
      post 'start'
      post 'finish'
      post 'cancel'
    end
  end

  resources :documents, only: %i[show]
end
