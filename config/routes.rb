Rails.application.routes.draw do


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :books
  
  resources :categories

  resources :authors

devise_for :users,
  defaults: { format: :json },
  controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks'
  }
  # rails g devise:controllers users gõ cái này nó sẽ tự sinh ra controller cho mình


# POST /users → đăng ký (sign up)

# POST /users/sign_in → đăng nhập (sign in)

# DELETE /users/sign_out → đăng xuất (sign out)

# POST /users/password → gửi email reset password

# PUT /users/password → đặt lại password với token

# POST /users/confirmation → gửi email xác nhận

# GET /users/confirmation → xác nhận tài khoản qua token

# POST /users/unlock → gửi email unlock

# GET /users/unlock → unlock account qua token
end
