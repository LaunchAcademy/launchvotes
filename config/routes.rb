Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "callbacks" }
  devise_scope :user do
    root to: "devise/sessions#new"
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :teams, only: [:show] do
    resources :nominations, only: [:create]
  end

  namespace :admin do
    resources :teams do
      resources :team_memberships, only: [:create], as: :memberships
    end
    resources :team_memberships, only: [:destroy]
  end
end
