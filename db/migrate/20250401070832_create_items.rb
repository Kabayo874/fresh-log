class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.integer :user_id, null: false
      t.integer :group_id
      t.string :title, null: false
      t.text :body, null: false
      t.integer :category, null: false
      t.timestamps
    end
  end
end
@