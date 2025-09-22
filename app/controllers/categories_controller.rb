class CategoriesController < ApplicationController

  before_action :set_category, only: [:show, :destroy, :update]

  def index
    @categories = Category.all
    render json: @categories
  end

  #Dùng để xem thử những category này có nghữ sách nào
  def show
    render json: @category.to_json(
      include: :books
    )
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      render json: @category, status: :created
    else
      render json: @category.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @category.update!(category_params)
      render json: @category , status: :ok
    else
      render json: @category.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.update(active: false)
      render json: { message: 'Category deleted successfully' }, status: :ok
    else
      render json: @category.errors.full_messages, status: :unprocessable_entity
    end
  end

  private 

  def set_category
    @category = Category.includes(:books).find(params[:id])
    if @category.nil?
      render json: { error: 'Category not found' }, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Category not found' }, status: :not_found
  end

  def category_params
    params.require(:category).permit(:category_name, :description, :active)
  end

end
