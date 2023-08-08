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
  resources :branches do
    get :join_company, on: :collection
  end
  resources :companies
  #resources :articles

  devise_scope :user do
    get 'choose_branch', to: 'devise/sessions#choose_branch'
  end

  root "home#home"

  get '/dashboard', to: 'dashboard#index', as: 'user_dashboard'
  get 'join_company', to: 'companies#join'

  get 'join_request/:company_id', to: 'companies#join_request', as: 'join_request'
  get 'join_now/:company_id', to: 'companies#join_now', as: 'join_now'

  get 'select_branch/:branch_id', to: 'branches#select_branch', as: 'select_branch'

  get '/contact', to: 'contact_customer#show_form', as: 'contact_form'
  post '/contact', to: 'contact_customer#send_email', as: 'send_contact'
end
