class BookCategory < ApplicationRecord
  belongs_to :book
  belongs_to :category

  #Có nghĩa là 1 thể loại có thể có nhiều sách , và khi xoá thể loại thì cũng xoá luôn trong bảng đó để tránh mồ côi
  has_many :book_categories, dependent: :destroy

  #Có nghĩa là có thể truy xuất đến các sách mà thể loại đó đã có thông qua bảng book_categories và ngược lại
  has_many :books, through: :book_categories
end
