class CreateGroupMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :group_members do |t|
      t.references :user, foreign_key: true
      t.references :proup, foreign_key: true
      t.boolean :status, null: false

      t.timestamps
    end
  end
end
