class AuthController < ApplicationController
  include Authenticatable
  before_action :authenticate_request, only: [:me]
  
  def login 
    @user = User.find_by(user_name: login_params[:user_name])
    if @user&.authenticate(login_params[:password])
      jwt_service = JwtService.new
      token = jwt_service.generate_tokens(@user)
      render json: { 
        success: true,
        message: 'Login successful',
        data:{
          access_token: token[:access], 
          refresh_token: token[:refresh], 
          user: @user 
        }
      }, status: :ok
    else
      render_error('Invalid User Name  or password')
    end
  end

  def register 
    @user = User.new(register_params)
    if @user.save
      render_success('User registered successfully', @user, :created)
    else
      render_error('User registration failed', @user.errors.full_messages)
    end
  end

  def me
    render_success('User profile retrieved', current_user)
  end
  
  private

  def login_params
    if params[:auth].present?
      params.require(:auth).permit(:user_name, :password)
    else
      params.permit(:user_name, :password)
    end
  end

  def register_params
    params.permit(:user_name, :email, :password, :role)
  end
end
