class AddExitReasonToGroupMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :group_members, :exit_reason, :integer
  end
end
