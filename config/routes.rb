Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "callbacks" }
  devise_scope :user do
    root to: "devise/sessions#new"
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :users, only: [:show]

  resources :teams, only: [:show] do
    resources :nominations, only: [:index, :create]
  end

  resources :nominations, only: [:edit, :update, :destroy]

  resources :nominations, only: :none do
    resources :votes, only: [:create, :destroy]
  end

  namespace :admin do
    resources :teams do
      resources :team_memberships, only: [:create], as: :memberships
    end
    resources :team_memberships, only: [:destroy]
  end

  namespace :api do
    namespace :v1 do
      resources :nominations, only: :none do
        resources :votes, only: [:create, :destroy]
      end
    end
  end
end
