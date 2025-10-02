class FixResetPasswordTokenIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :users, name: :index_users_on_reset_password_token
    add_index :users, :reset_password_token, unique: true, where: "reset_password_token IS NOT NULL"
  end
end
