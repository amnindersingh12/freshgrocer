# frozen_string_literal: true

Rails.application.routes.draw do
  # Devise routes for authentication
  devise_for :users

  # Customer-facing routes
  root 'home#index'

  # SEO-friendly product and category routes
  resources :products, only: %i[index show], param: :slug
  resources :categories, only: %i[index show], param: :slug

  # Cart management
  resource :cart, only: [:show] do
    post :add_item
    patch :update_item
    delete :remove_item
  end

  # Checkout and orders
  resources :orders, only: %i[index new create show]

  # Customer account area
  namespace :account do
    resource :profile, only: %i[show edit update]
    resources :orders, only: %i[index show]
    resources :addresses do
      member do
        patch :set_default
      end
    end
  end

  # Admin namespace (restricted to admins)
  namespace :admin do
    root 'dashboard#index'

    resources :dashboard, only: [:index]
    resources :products do
      resources :product_variants, except: [:index], path: 'variants'
    end
    resources :categories
    resources :orders, only: %i[index show update]
    resources :users, only: %i[index update]
  end

  # Health check
  get 'up' => 'rails/health#show', as: :rails_health_check
end
