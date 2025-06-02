class ChangeStatusToIntegerInGroups < ActiveRecord::Migration[6.1]
  def up
    change_column :groups, :status, :integer, default: 0, null: false
  end

  def down
    change_column :groups, :status, :boolean, default: true, null: false
  end
end
