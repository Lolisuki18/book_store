class UserDetailsController < ApplicationController
  include Authenticatable
  before_action :set_user_detail, only: [:show, :update]
  # skip_before_action :authenticate_request, only: [:index, :show]
  before_action only: [:create, :index] do
    authorize_role(:admin, :staff, :manager)
  end

  def index
    @user_details = UserDetail.all
    render_success('User details retrieved successfully', @user_details)
  end

  def show
    render_success('User detail retrieved successfully', @user_detail)
  end

  def create
    @user_detail = UserDetail.new(user_detail_params)
    if @user_detail.save
      render_success('User detail created successfully', @user_detail, :created)
    else
      render_error('User detail creation failed', @user_detail.errors.full_messages)
    end
  end

  def update
    if @user_detail.update(user_detail_params)
      render_success('User detail updated successfully', @user_detail)
    else
      render_error('User detail update failed', @user_detail.errors.full_messages)
    end
  end

  #Chỉ nên destroy khi user bị xoá 
  # def destroy
  #   if @user_detail.destroy
  #     render_success('User detail deleted successfully')
  #   else
  #     render_error('User detail deletion failed', @user_detail.errors.full_messages)
  #   end
  # end

  private

  def set_user_detail
    @user_detail = UserDetail.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      message: 'User detail not found',
      success: false
    }, status: :not_found
  end

  def user_detail_params
    params.require(:user_detail).permit(:user_id, :full_name, :phone, :address, :date_of_birth , :profile_picture_url, :gender)
  end
end
