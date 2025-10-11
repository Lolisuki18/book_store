class AddActiveToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :active, :boolean, default: true
  end
end
