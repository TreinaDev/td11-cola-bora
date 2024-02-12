Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  root to: "home#index"

  resources :profiles, only: %i[edit update show]
  resources :projects, only: %i[new create show index edit update destroy] do
    resources :tasks, only: %i[index new create show edit update] do
      member do
        patch 'start'
        patch 'finish'
        patch 'cancel'
      end
    end
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
    resources :proposals, only: %i[index]
    resources :calendars, only: %i[index]

    get 'forum', to: 'forums#index'
  end

  resources :user_roles, only: [] do
    patch :remove, on: :member
  end

  resources :invitations, only: %i[index show] do
    patch 'accept', on: :member
    patch 'decline', on: :member
  end

  resources :proposals, only: [] do
    patch :decline, on: :member
  end

  resources :documents, only: %i[show] do
    patch 'archive', on: :member
  end

  resources :meetings, only: %i[] do
    resources :meeting_participants, only: %i[new create]
  end

  namespace :api do
    namespace :v1 do
      resources :projects, only: %i[index]
      resources :invitations, only: %i[index update]
      resources :proposals, only: %i[create]
    end
  end
end
