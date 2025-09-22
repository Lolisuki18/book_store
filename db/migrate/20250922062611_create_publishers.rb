class CreatePublishers < ActiveRecord::Migration[8.0]
  def change
    create_table :publishers do |t|
      t.string :publisher_name
      t.text :address
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
