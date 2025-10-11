Rails.application.routes.draw do
  get "authrails/generate"
  get "authrails/controller"
  get "authrails/auth"
  # Swagger UI routes
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  # Auth routes for Swagger
  post 'auth/login', to: 'auth#login'
  post 'auth/register', to: 'auth#register'
  get 'auth/me', to: 'auth#me'
  post '/auth/refresh', to: 'auth#refresh'

  resources :books
  
  resources :categories

  resources :authors
  
  resources :users

  resources :user_details

end
