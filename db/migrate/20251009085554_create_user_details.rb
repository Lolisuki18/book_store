class CreateUserDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :user_details do |t|
      t.references :user, null: false, foreign_key: true
      t.string :full_name, null: false
      t.string :phone_number, null: false
      t.text :address
      t.date :date_of_birth
      t.string :gender, null: false
      t.string :avatar_url
      t.string :nickname

      t.timestamps
    end
  end
end
