class RemoveStatusFromGroups < ActiveRecord::Migration[6.1]
  def change
    remove_column :groups, :status, :boolean
  end
end
