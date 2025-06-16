class AddPrivateToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :private, :boolean
  end
end
