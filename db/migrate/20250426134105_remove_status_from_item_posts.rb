class RemoveStatusFromItemPosts < ActiveRecord::Migration[6.1]
  def change
    remove_column :item_posts, :status, :integer
  end
end
