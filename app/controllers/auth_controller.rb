class AuthController < ApplicationController
  include Doorkeeper::Rails::Helpers
  
  before_action :doorkeeper_authorize!, except: [:login, :refresh]

  # POST /auth/login
  def login
    user = User.find_by(user_name: params[:user_name])
    
    if user&.authenticate(params[:password])
      # Revoke của user này để chỉ có 1 token active
      revoke_user_tokens(user.id)
      
      # Tạo token mới
      access_token = create_custom_token(user)
      
      #Trả lại json nếu đăng nhập thành công 
      render json: {
        access_token: access_token.token,
        refresh_token: access_token.refresh_token,
        token_type: 'Bearer',
        expires_in: access_token.expires_in,
        user: {
          id: user.id,
          user_name: user.user_name,
          email: user.email,
          role: user.role
        }
      }
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  # POST /auth/refresh
  def refresh
    refresh_token = params[:refresh_token]
    
    if refresh_token.blank?
      render json: { error: 'Refresh token is required' }, status: :bad_request
      return
    end

    # Tìm access token bằng refresh token
    access_token = Doorkeeper::AccessToken.find_by(refresh_token: refresh_token)
    
    if access_token.nil? || access_token.revoked? || access_token.expired?
      render json: { error: 'Invalid or expired refresh token' }, status: :unauthorized
      return
    end

    # Revoke token cũ
    access_token.update(revoked_at: Time.current)
    
    # Tạo token mới
    user = User.find(access_token.resource_owner_id)
    new_token = create_custom_token(user)
    
    render json: {
      access_token: new_token.token,
      refresh_token: new_token.refresh_token,
      token_type: 'Bearer',
      expires_in: new_token.expires_in
    }
  end

  # POST /auth/logout
  def logout
    if doorkeeper_token
      doorkeeper_token.revoke
      render json: { message: 'Logged out successfully' }
    else
      render json: { error: 'No active session' }, status: :unauthorized
    end
  end

  # GET /auth/me
  def me
    user = current_user
    if user
      render json: {
        id: user.id,
        user_name: user.user_name,
        email: user.email,
        role: user.role
      }
    else
      render json: { error: 'User not found' }, status: :unauthorized
    end
  end

  private

  def create_custom_token(user)
    application = get_or_create_application
    
    # Tạo access token trực tiếp mà không qua grant flow
    Doorkeeper::AccessToken.create!(
      application: application,
      resource_owner_id: user.id,
      expires_in: Doorkeeper.configuration.access_token_expires_in,
      scopes: 'public',
      use_refresh_token: true
    )
  end

  def get_or_create_application
    # Tìm hoặc tạo một default application
    Doorkeeper::Application.first || Doorkeeper::Application.create!(
      name: "BookStore Default App",
      redirect_uri: "",
      confidential: false,
      scopes: "public"
    )
  end

  def revoke_user_tokens(user_id)
    # Revoke tất cả token hiện tại của user
    Doorkeeper::AccessToken.where(
      resource_owner_id: user_id, 
      revoked_at: nil
    ).update_all(revoked_at: Time.current)
  end

  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
