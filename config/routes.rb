# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :time_sheets, only: %i[create index], path: 'timesheets'
  end
  mount_devise_token_auth_for 'User', at: 'auth'
  scope path: '/admin' do
    resources :orders, only: [:index]
  end
  scope path: 'api' do
    resources :orders, only: [:create]
  end
end
