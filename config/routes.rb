Rails.application.routes.draw do
  resources :schedules
  resources :deliveries
  resources :availabilities
  devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
      }

  get '/users/fetch_users', to: 'users#fetch_users'
  resources :users
  resources :branches
  resources :companies
  resources :articles

  devise_scope :user do
    get 'choose_branch', to: 'devise/sessions#choose_branch'
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   
  root "home#home"

   get '/dashboard', to: 'dashboard#index', as: 'user_dashboard'
   get 'join_company', to: 'companies#join'

   get 'join_request/:company_id', to: 'companies#join_request', as: 'join_request'
   get 'join_now/:company_id', to: 'companies#join_now', as: 'join_now'
end
