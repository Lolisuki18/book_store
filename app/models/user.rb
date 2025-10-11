class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :user_name, presence: true, uniqueness: true
  has_one :user_detail, dependent: :destroy

  enum :role, { user: 'user', admin: 'admin', staff: 'staff', manager: 'manager' }, default: :user

end
