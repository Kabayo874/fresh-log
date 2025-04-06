class CreateGroupMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :group_members do |t|
      t.integer :user_id, null: false
      t.integer :proup_id, null: false
      t.boolean :status, null: false

      t.timestamps
    end
  end
end
