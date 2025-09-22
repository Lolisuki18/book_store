class Author < ApplicationRecord
  #Validations
  validates :name, presence: true
end
