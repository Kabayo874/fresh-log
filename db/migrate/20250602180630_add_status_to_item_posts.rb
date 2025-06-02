class AddStatusToItemPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :item_posts, :status, :integer, default: 0, null: false
  end
end
