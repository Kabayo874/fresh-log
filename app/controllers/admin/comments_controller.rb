class Admin::CommentsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def destroy
    @item = Item.find(params[:item_id])
    @comment = @item.comments.find(params[:id])
    @comment.destroy
    redirect_to admin_item_path(@item), notice: '追加投稿を削除しました。'
  end
end
