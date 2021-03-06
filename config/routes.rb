Rails.application.routes.draw do
  get "/contact", to: "pages#contact", as: :pages_contact
  get "/", to: "pages#home", as: :pages_home
  get "/trial", to: "pages#trial", as: :pages_trial
  get "/my_teacher", to: "pages#my_teacher", as: :my_teacher

  namespace :api do
    resources :stripe_webhook_events, only: [:create]
  end

  resources :user_lessons, only: [:create]

  resources :stripe_products, only: [:show]

  scope :back do
    resources :imports
    resources :lessons
    resources :chapters
    resources :categories
    resources :levels
    resources :users, only: [:index, :show]
  end

  resources :contact_messages, only: [:new, :create]
  resources :chat_rooms, only: [:show] do
    resources :chat_messages, only: [:new, :create]
  end
    # resources :chat_participants, only: [:new, :create]

  devise_for :users
end
