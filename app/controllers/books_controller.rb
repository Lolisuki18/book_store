class BooksController < ApplicationController
  before_action :set_book, only: [:show, :update, :destroy]

  def index
    @books = Book.all
     render json: @books.to_json(
  include: [:publisher, :authors , :categories]
     )
  end

  def show
  # render json: @book
    render json: @book.to_json(
    include: [:publisher, :authors, :categories]
  #nó sé trả luôn thông tin của các bảng liên quan (publisher, authors, categories)
  ) 
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      render json: @book, status: :created
    else
      render json: @book.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @book.update(book_params)
      render json: @book , status: :ok
    else
      render json: @book.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    if @book.update(active: false)
      render json: { message: 'Book delete successfully' } , status: :ok
    else
      render json: @book.errors.full_messages, status: :unprocessable_entity
    end
  end

  private 

  def set_book
    @book = Book.includes(:publisher, :authors, :categories).find(params[:id])
    if @book.nil?
      render json: { error: 'Book not found' }, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Book not found' }, status: :not_found
  end
  def book_params
    params.require(:book).permit(:page_count,:title, :publisher_id, :isbn, :publication_date, :price, :stock_quantity, :description, :active, :language , :cover_image_url)
  end

end
