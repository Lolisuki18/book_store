class AuthorsController < ApplicationController
    include Authenticatable

  before_action :set_author, only: [:show, :update, :destroy]

  before_action only: [:create, :update, :destroy] do
      authorize_role(:admin, :staff)
  end
  def index 
    @authors = Author.all
    render json: @authors
  end

  def show
    render json: @author.to_json(
      include: :books
    )
  end

  def create
    @author = Author.new(author_params)
    if @author.save
      render json: @author, status: :created
    else
      render json: @author.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update 
    if @author.update(author_params)
      render json: @author , status: :ok
    else
      render json: @author.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    if @author.update(active: false)
      render json: { message: 'Author deleted successfully' }, status: :ok
    else
      render json: @author.errors.full_messages, status: :unprocessable_entity
    end
  end


  private 
  def set_author
    @author = Author.includes(:books).find(params[:id])
    if @author.nil?
      render json: { error: 'Author not found' }, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Author not found' }, status: :not_found
  end

  def author_params
    params.require(:author).permit(:first_name, :last_name, :biography, :birth_date, :nationality, :active, :stage_name)
  end
end
