Rails.application.routes.draw do
  devise_for :users

  scope "(:locale)", locale: /en|ja|ne/ do
    root to: "pages#home"

    resources :conversations, only: [:index, :show, :create, :destroy] do
      resources :chat_messages, only: [:create]
    end

    resources :documents, only: [:index, :show, :new, :create, :destroy]

    get "chat", to: "conversations#index", as: :chat
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
