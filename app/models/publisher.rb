class Publisher < ApplicationRecord

  #Validations
  validates :publisher_name, presence: true

  validates :address, presence: true

  validates :phone_number, presence: true

  validates :email, presence: true, uniqueness: true, 
  format: { with: URI::MailTo::EMAIL_REGEXP,  message: "Email format is invalid" }


end
