Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  root to: "home#index"

  resources :profiles, only: %i[edit update show]
  resources :projects, only: %i[new create show index edit update destroy] do
    resources :tasks, only: %i[index new create]
    resources :documents, only: %i[index new create]
    resources :meetings, only: %i[index new create show edit update]
    get 'members', on: :member, to: 'projects#members'

    resources :portfoliorrr_profiles, only: %i[show] do
      get 'search', on: :collection

      resources :invitations, shallow: true, only: %i[create] do
        member do
          patch 'cancel', to: 'invitations#cancel'
        end
      end
    end

    resources :user_roles, only: %i[edit update]
  end

  resources :user_roles, only: [] do
    patch :remove, on: :member
  end

  resources :invitations, only: %i[index show] do
    patch 'accept', on: :member
    patch 'decline', on: :member
  end

  resources :tasks, only: %i[show edit update] do
    member do
      post 'start'
      post 'finish'
      post 'cancel'
    end
  end

  resources :documents, only: %i[show] do
    patch 'archive', on: :member
  end

  namespace :api do
    namespace :v1 do
      resources :projects, only: %i[index]
      resources :invitations, only: %i[index update]
    end
  end
end
