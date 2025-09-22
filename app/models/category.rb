class Category < ApplicationRecord
  #Validations
  validates :category_name, presence: true, uniqueness: true
end
