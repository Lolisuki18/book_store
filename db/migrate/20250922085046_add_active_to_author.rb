class AddActiveToAuthor < ActiveRecord::Migration[8.0]
  def change
    add_column :authors, :active, :boolean , default: true
  end
end
