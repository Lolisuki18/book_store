class AddActiveToCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :active, :boolean, default: true 
  end
end
