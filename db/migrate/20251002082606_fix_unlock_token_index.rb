class FixUnlockTokenIndex < ActiveRecord::Migration[8.0]
 def change
    remove_index :users, name: :index_users_on_unlock_token
    add_index :users, :unlock_token, unique: true, where: "unlock_token IS NOT NULL"
  end
end
