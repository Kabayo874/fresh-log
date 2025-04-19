class AddDefaultToGroupMemberStatus < ActiveRecord::Migration[6.1]
  def change
    change_column_default :group_members, :status, from: nil, to: true
    change_column_null :group_members, :status, false
  end
end
