Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: {
                                    omniauth_callbacks: 'oauth_callbacks',
                                    confirmations: 'email_confirmations'
                                  }

  concern :voted do
    member do
      patch :vote_up
      patch :vote_down
      delete :cancel_vote
    end
  end

  concern :commentable do
    resources :comments, only: :create, shallow: true
  end

  resources :questions, concerns: %i[voted commentable] do
    resources :answers, shallow: true, concerns: %i[voted commentable] do
      patch :set_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :rewards, only: :index
  resources :links, only: :destroy

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: [:index]
    end
  end

  root to: 'questions#index'

   mount ActionCable.server => '/cable'
end
