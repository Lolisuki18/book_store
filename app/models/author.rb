class Author < ApplicationRecord
  #Validations
  validates :first_name, presence: true , length: { maximum: 50 }

  validates :last_name, presence: true,  length: { maximum: 50 }
  validates :nationality, presence: true

  validates :stage_name, uniqueness: true, allow_nil: true

  #Có nghĩa là 1 tác giả có thể viết nhiều sách , và khi xoá tác giả thì cũng xoá luôn trong bảng đó để tránh mồ côi 
  has_many :book_authors, dependent: :destroy

  #Có nghĩa là có thể truy xuất đến các sách mà tác giả đó đã viết thông qua bảng book_authors và ngược lại
  has_many :books, through: :book_authors
end
