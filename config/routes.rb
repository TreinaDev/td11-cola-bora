Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  root to: "home#index"

  resources :profiles, only: %i[edit]
  resources :projects, only: %i[new create show index edit destroy] do
    get 'my_projects', on: :collection
  end
end
