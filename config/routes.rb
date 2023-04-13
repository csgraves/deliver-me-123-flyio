Rails.application.routes.draw do
  resources :lesson_payments
  resources :bookings
  resources :users
  resources :accounts
  resources :schedules
  resources :clients
  resources :trainers
  resources :lessons
  resources :articles
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   root "articles#index"
end
