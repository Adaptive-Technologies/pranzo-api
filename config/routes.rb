# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :users, only: [:index]
    resources :time_sheets, only: %i[create index], path: 'timesheets'
  end
  mount_devise_token_auth_for 'User',
                              at: 'auth',
                              controllers: { registrations: 'overrides/registrations' }
  scope path: 'admin' do
    resources :vouchers, only: %i[index create update] do
      resources :transactions, only: [:create]
      post 'vouchers/purchases', controller: :purchases, action: :create
    end
    resources :orders, only: [:index]
  end
  scope path: 'api' do
    resources :vouchers, only: [:show]
    post 'vouchers/purchases', controller: :purchases, action: :create
    resources :orders, only: [:create]
    resources :services, only: [:index]
    resources :products, only: [:index]
    resources :vendors, only: %i[create show update] do
      resources :reports, only: %i[create]
      resources :affiliates, only: %i[create]
      resources :vouchers, only: %i[create index update] do
        resources :transactions, only: %i[create]
        post :generate_card, controller: :vouchers, action: :generate_card
      end
    end
    post :validate_user, controller: :users # , action: :validate_user
  end
end
