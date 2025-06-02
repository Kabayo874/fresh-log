class RenameDiscriptionToDescriptionInGroups < ActiveRecord::Migration[6.1]
  def change
    rename_column :groups, :discription, :description
  end
end
