class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.integer :owner_user_id, null: false
      t.string :name, null: false
      t.text :discription, null: false
      t.boolean :status, null: false

      t.timestamps
    end
  end
end
