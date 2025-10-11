class ApplicationController < ActionController::API
  include Doorkeeper::Rails::Helpers

  # Xử lý các exception từ Doorkeeper
  rescue_from Doorkeeper::Errors::TokenExpired, with: :token_expired
  rescue_from Doorkeeper::Errors::TokenRevoked, with: :token_revoked
  rescue_from Doorkeeper::Errors::TokenUnknown, with: :token_unknown

  protected

  def current_user
    return nil unless doorkeeper_token
    return nil if doorkeeper_token.expired?
    
    @current_user ||= User.find_by(id: doorkeeper_token.resource_owner_id)
  end

  def authenticate_user!
    doorkeeper_authorize!
  rescue Doorkeeper::Errors::TokenExpired
    token_expired
  rescue Doorkeeper::Errors::TokenRevoked
    token_revoked
  rescue Doorkeeper::Errors::TokenUnknown
    token_unknown
  end

  private

  def token_expired
    render json: {
      error: 'Token expired',
      message: 'Your access token has expired. Please refresh your token or login again.',
      code: 'TOKEN_EXPIRED'
    }, status: :unauthorized
  end

  def token_revoked
    render json: {
      error: 'Token revoked',
      message: 'Your access token has been revoked. Please login again.',
      code: 'TOKEN_REVOKED'
    }, status: :unauthorized
  end

  def token_unknown
    render json: {
      error: 'Invalid token',
      message: 'The access token is invalid or malformed.',
      code: 'TOKEN_INVALID'
    }, status: :unauthorized
  end
end
