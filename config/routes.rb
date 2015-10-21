Rails.application.routes.draw do
  root to: "home#index"
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :standup_notes, only: :create

end
