class AddStatusToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :status, :boolean, default: true
  end
end