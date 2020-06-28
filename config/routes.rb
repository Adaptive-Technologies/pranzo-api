# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  get 'orders/create'
  scope path: 'api' do
    resources :orders, only: [:create]
  end
end
