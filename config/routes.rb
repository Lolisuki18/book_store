Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Doorkeeper routes (chỉ mount những gì cần thiết)
  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications, :tokens
  end
  
  # Auth routes
  post 'auth/login', to: 'auth#login'
  post 'auth/refresh', to: 'auth#refresh'
  post 'auth/logout', to: 'auth#logout'
  get 'auth/me', to: 'auth#me'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  
  # Protected resources - sẽ cần authentication
  resources :books
  resources :categories  
  resources :authors
end
