class AuthController < ApplicationController
  include Authenticatable
  before_action :authenticate_request, only: [:me]
  
  def login 
    @user = User.find_by(user_name: login_params[:user_name]) || User.find_by(email: login_params[:user_name])
    if @user&.authenticate(login_params[:password])
      jwt_service = JwtService.new
      token = jwt_service.generate_tokens(@user)
      render json: { 
        success: true,
        message: 'Login successful',
        data:{
          access_token: token[:access], 
          refresh_token: token[:refresh], 
          user: @user.as_json(except: [:password_digest, :created_at, :updated_at])
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
    @user = User.find(current_user.id)
    render_success('User profile retrieved', @user.as_json(except: [:password_digest, :created_at, :updated_at]))
  end
  
  
  def refresh
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    jwt_service = JwtService.new
    decoded = jwt_service.decode(token)

    # Kiểm tra loại token
    unless decoded && decoded[:type] == "refresh"
      return render json: { error: "Invalid token type" }, status: :unauthorized
    end

    user = User.find_by(id: decoded[:user_id])
    return render json: { error: "User not found" }, status: :unauthorized unless user

    # Tạo access token mới
    new_access_token = JsonWebToken.encode({ user_id: user.id, type: "access" }, 1.hour.from_now)

    render json: {
      access_token: new_access_token,
      refresh_token: token 
    }, status: :ok
  rescue JWT::DecodeError
    render json: { error: "Invalid or expired token" }, status: :unauthorized
  end

  private

  def login_params
      params.permit(:user_name, :password)
  end

  def register_params
    params.permit(:user_name, :email, :password, :role,:full_name, :phone, :address, :date_of_birth, 
                                  :gender, :profile_picture_url)
  end

end
