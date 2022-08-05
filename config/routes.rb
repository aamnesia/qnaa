require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

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
    resources :subscriptions, only: %i[create destroy], shallow: true
  end

  resources :attachments, only: :destroy
  resources :rewards, only: :index
  resources :links, only: :destroy
  resources :searches, only: :index

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, except: %i[new edit] do
        resources :answers, except: %i[new edit], shallow: true
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
