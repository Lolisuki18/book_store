class User < ApplicationRecord
  has_secure_password
  
  # Validations
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validates :user_name, presence: true, uniqueness: true
  validates :full_name, presence: true
  validates :phone, presence: true, uniqueness: true
  validates :gender, presence: true
  validates :address,presence: true

  # Enums
  enum :role, { user: 'user', admin: 'admin', staff: 'staff', manager: 'manager' }, default: :user
  enum :gender, { male: "Male", female: "Female", other: "Other" }

def safe_json
    as_json(except: [:password_digest, :created_at, :updated_at])
  end

  private
  # dùng cho cập nhập sẽ ko cần mật khẩu
  def password_required?
    new_record? || !password.nil?
  end

 
end
