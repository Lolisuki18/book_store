class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :isbn
      t.text :description
      t.decimal :price
      t.integer :stock_quantity
      t.date :publication_date
      t.integer :page_count
      t.string :language
      t.string :cover_image_url
      t.references :publisher, null: false, foreign_key: true

      t.timestamps
    end
  end
end
