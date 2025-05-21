class RenameUseIdToUserIdInComments < ActiveRecord::Migration[6.1]
  def change
    rename_column :comments, :use_id, :user_id
  end
end