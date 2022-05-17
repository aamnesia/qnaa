Rails.application.routes.draw do
  devise_for :users

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

  root to: 'questions#index'

   mount ActionCable.server => '/cable'
end
