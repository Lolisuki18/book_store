class AddStageNameToAuthors < ActiveRecord::Migration[8.0]
  def change
    add_column :authors, :stage_name, :string
  end
end
