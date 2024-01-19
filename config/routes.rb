Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  root to: "home#index"

  resources :projects, only: [:new, :create, :show, :index] do
    get 'my_projects', on: :collection
  end

  resources :profiles, only: %i[edit]

end
