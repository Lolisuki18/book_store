class Book < ApplicationRecord
  belongs_to :publisher

  #Validations
  
  validates :title, presence: true

  validates :isbn, presence: true, uniqueness: true

  validates :price, numericality: { greater_than_or_equal_to: 0 }, presence: true

  validates :stock_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true

  validates :publication_date, presence: true

  validates :page_count, numericality: { only_integer: true, greater_than: 1 }, presence: true

  validates :language, presence: true

  # validates :cover_image_url, allow_blank: true
  #bỏ đi vì allow_blank chỉ dùng được khi có 1 thuộc tính khác để validate cùng


  #Mối quan hệ nhiều nhiều với authors, nếu xoá sách xoá luôn trong bảng trung gian luôn
  has_many :book_authors, dependent: :destroy
  #Sách có thể truy xuất đến các tác giả thông qua bảng book_authors và ngược lại
  has_many :authors, through: :book_authors

  #Mối quan hệ nhiều nhiều với categories
  has_many :book_categories, dependent: :destroy
  has_many :categories, through: :book_categories

end
