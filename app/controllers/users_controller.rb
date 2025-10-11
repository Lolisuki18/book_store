class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:create]
  before_action :ensure_permission, only: [:index]
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :ensure_admin, only: [:destroy]
  def index
    @users = User.all
    render json: @users.as_json(except: [:password_digest], include: :user_detail)
  end
  # register new user
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: @user.to_json(include: :user_detail)
  end

  def update 
    if @user.update(user_params)
      render json: @user , status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
     if @user.update(active: false)
      render json: { message: 'User deleted successfully' }, status: :ok
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  def user_params
    params.require(:user).permit(:user_name, :email, :password, :role, :active)
  end

  def ensure_permission
    render json: { error: 'Unauthorized. Admin access required.' }, status: :forbidden unless current_user&.admin?
  end

  def ensure_admin
    render json: { error: 'Unauthorized.' }, status: :forbidden unless current_user&.admin?
  end
end
