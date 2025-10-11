class UserDetail < ApplicationRecord
  belongs_to :user

  validates :full_name, :phone_number, :gender, presence: true

  enum :gender, { male: 'Nam', female: 'Nữ', other: 'Khác' }, default: 'Khác'

  VALID_PHONE_REGEX = /\A0\d{9,10}\z/
  validates :phone_number, presence: true, format: { with: VALID_PHONE_REGEX, message: "không hợp lệ. Vui lòng nhập số bắt đầu bằng 0 và có 10–11 chữ số." }

end
