# frozen_string_literal: true

Rails.application.routes.draw do
  get 'orders/create'
  scope path: 'api' do
    resources :orders, only: [:create]
  end
end
