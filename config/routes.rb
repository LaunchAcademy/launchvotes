Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "callbacks" }
  devise_scope :user do
    root to: "devise/sessions#new"
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :nominations, only: [:index]

  namespace :admin do
    resources :teams, only: [:index, :show]
  end
end
