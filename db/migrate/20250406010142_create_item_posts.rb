class CreateItemPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :item_posts do |t|
      t.integer :user_id, null: false
      t.integer :item_id, null: false
      t.integer :status, null: false
      t.text :review, null: false

      t.timestamps
    end
  end
end
