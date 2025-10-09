class RenamePasswodDigestToPasswordDigest < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :passwod_digest, :password_digest
  end
end