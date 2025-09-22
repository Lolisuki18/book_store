class Book < ApplicationRecord
  belongs_to :publisher

  #Validations
  
  validates :title, presence: true

  validates :isbn, presence: true, uniqueness: true

  validates :price, numericality: { greater_than_or_equal_to: 0 }, presence: true

  validates :stock_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true

  validates :publication_date, presence: true

  validates :page_count, numericality: { only_integer: true, greater_than:= 1 }, presence: true

  validates :language, presence: true

  validates :cover_image_url, allow_blank: true


end
