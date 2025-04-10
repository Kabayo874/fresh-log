class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.integer :owner_id, null: false
      t.string :name, null: false
      t.text :discription, null: false
      t.boolean :status, null: false
      t.string :image_id

      t.timestamps
    end
  end
end
