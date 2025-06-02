class Admin::ItemPostsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def destroy
    @item = Item.find(params[:item_id])
    @item_post = @item.item_posts.find(params[:id])
    @item_post.destroy
    redirect_to admin_item_path(@item), notice: '追加投稿を削除しました。'
  end
end
