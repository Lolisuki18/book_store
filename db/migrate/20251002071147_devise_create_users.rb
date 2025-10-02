# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      ## Database authenticatable # Đăng nhập bằng email và password.
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable Cho phép user reset password qua email.
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable # Dùng cho chức năng “Remember me” trên web.
      # t.datetime :remember_created_at

      ## Trackable -> Ghi lại lịch sử đăng nhập (số lần, IP, thời gian).
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      # Confirmable -> Nếu bạn muốn user phải xác thực email trước khi dùng tài khoản  nên mở comment ra .
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable
      # Dùng để xác thực email khi đăng ký (gửi mail confirm).


      # Lockable -> Dùng để khóa tài khoản sau nhiều lần login sai (chống brute force).
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at
      


      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
    # confirmation_token và unlock_token chỉ cần mở cmt nếu bật confirmable/lockable.
  end
end
