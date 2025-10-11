class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :user_name, presence: true, uniqueness: true

  enum :role, { user: 'user', admin: 'admin', staff: 'staff', manager: 'manager' }, default: :user

end
