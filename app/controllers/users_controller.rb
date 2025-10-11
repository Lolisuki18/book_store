class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  
  def index
    if @user&.admin? || @user&.manager? || @user&.staff?
      @users = User.all
      render json: {
        message: 'Users retrieved successfully',
        data: @users
      }, status: :ok
    else
      render json: {
        message: 'Access denied'
      }, status: :forbidden
    end
  end

   def show
    render json: {
      message: 'User retrieved successfully',
      data: @user
    }, status: :ok
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: {
        message: 'User created successfully',
        data: @user,
      }, status: :created
    else
      render json: {
        message: 'User creation failed',
        errors: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: {
        message: 'User updated successfully',
        data: @user
      }, status: :ok
    else
      render json: {
        message: 'User update failed',
        errors: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.update(active: false)
      render json: {
        message: 'User deleted successfully'
      }, status: :ok
    else
      render json: {
        message: 'User deletion failed',
        errors: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
    if @user.nil?
      render json: { error: 'User not found' }, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  def user_params
    params.require(:user).permit(:user_name, :email, :password, :role, :active)
  end
end
