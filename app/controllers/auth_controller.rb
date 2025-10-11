class AuthController < ApplicationController
  include Doorkeeper::Rails::Helpers
  
  before_action :doorkeeper_authorize!, except: [:login, :refresh]

  # POST /auth/login
  def login
    #Tìm kiếm user với user_name này 
    user = User.find_by(user_name: params[:user_name])
    
    if user&.authenticate(params[:password]) # nếu có thì so sánh password xem có trùng không
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
    
   if access_token.nil?
      render json: { error: 'Invalid refresh token' }, status: :unauthorized
      return
    end
    
    if access_token.revoked?
      render json: { error: 'Refresh token has been revoked' }, status: :unauthorized
      return
    end
    
    # Kiểm tra access token expiration (cho access token)
    if access_token.expired?
      render json: { error: 'Access token has expired' }, status: :unauthorized
      return
    end
    
    # Kiểm tra refresh token expiration (nếu có set)
    if refresh_token_expired?(access_token)
      render json: { error: 'Refresh token has expired. Please login again.' }, status: :unauthorized
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

  def refresh_token_expired?(access_token)
    return false unless access_token.refresh_token
    
    # Lấy refresh token expiration từ Doorkeeper config
    refresh_expires_in = Doorkeeper.configuration.refresh_token_expires_in
    return false unless refresh_expires_in
    
    # Check nếu refresh token đã hết hạn
    access_token.created_at + refresh_expires_in < Time.current
  end
  
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
