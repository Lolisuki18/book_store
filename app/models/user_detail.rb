class UserDetail < ApplicationRecord
  belongs_to :user

  #Validations 
  validates :full_name, presence: true
  validates :phone, presence: true , uniqueness: true
  validates :address, presence: true
  validates :gender, presence: true
  validates :user_id, presence: true, uniqueness: true
  

  #enum 
  enum :gender, { male: "Male", female: "Female", other: "Other" }
  
  
  # suffix: true
  # Rails sẽ tạo ra các method như:

  # male_gender?
  # female_gender?
  # other_gender?
  # user_detail.male_gender!
  # user_detail.gender
  # Nếu không có _suffix: true, các method sẽ là male?, female?, 
  # ... có thể bị trùng với các method khác.
end
