class UsersController < ApplicationController
  include Authenticatable
  before_action :set_user, only: [:show, :update, :destroy]
  skip_before_action :authenticate_request, only: [:index, :show]

  before_action only: [:create, :update , :index] do
    authorize_role(:admin, :staff, :manager)
  end

  before_action only: [:destroy] do
    authorize_role(:admin , :manager)
  end

  def index
      @users = User.all
      render json: {
        message: 'Users retrieved successfully',
        data: @users
      }, status: :ok
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
          message: 'User delete failed',
          errors: @user.errors.full_messages
        }, status: :unprocessable_entity
      end
  end

  private
  
  def set_user
    @user = User.find(params[:id])
    if @user.nil?
      render json: { 
        message: 'User not found',
        success: false 
      }, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound
    render json: { 
      message: 'User not found',
      success: false 
    }, status: :not_found
  end

  def user_params
    params.permit(:user_name, :email, :password, :role, :active, 
                                  :full_name, :phone, :address, :date_of_birth, 
                                  :gender, :profile_picture_url)
  end
end
