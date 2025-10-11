module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request
    attr_reader :current_user
  end

  private

  
  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      decoded = JsonWebToken.decode(header)
      if !decoded
        render json: { errors: 'Token is invalid' }, status: :unauthorized
      end
      @current_user = User.find(decoded[:user_id])
      if(!@current_user || !@current_user.active?)
        render json: { errors: 'Cannot find user or user is inactive' }, status: :unauthorized
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  #Check quyền 

  def authorize_role(*roles)
    unless roles.any? { |r| current_user&.send("#{r}?") }
      render json: { error: 'Role not authorized' }, status: :forbidden
    end
  end

  #send("#{r}?") gọi phương thức động dựa trên tên vai trò được truyền vào.
  # Nếu r = :admin → gọi current_user.admin?
  # Nếu r = :staff → gọi current_user.staff?


  # #User 
  # def user_role
  #   unless @current_user&.user? 
  #     render json: { message: 'Access denied : User role can not do this action' }, status: :forbidden
  #   end
  # end

  # #staff 
  # def staff_role
  #   unless @current_user&.staff?
  #     render json: { message: 'Access denied : Staff role can not do this action' }, status: :forbidden
  #   end
  # end

  # #admin 
  # def admin_role
  #   unless @current_user&.admin?
  #     render json: { message: 'Access denied : Admin role can not do this action' }, status: :forbidden
  #   end
  # end
  # def manager_role
  #   unless @current_user&.manager?
  #     render json: { message: 'Access denied : Manager role can not do this action' }, status: :forbidden
  #   end
  # end
end