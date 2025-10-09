class ApplicationController < ActionController::API
  include Doorkeeper::Rails::Helpers

  protected

  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def authenticate_user!
    doorkeeper_authorize!
  end
end
