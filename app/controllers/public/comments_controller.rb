class Public::CommentsController < ApplicationController

  def create
    item = Item.find(params[:item_id])
    comment = current_user.comments.new(comment_params)
    comment.item_id = item.id
    comment.save
    redirect_to item_path(item)
  end

  def destroy
    @item = Item.find(params[:item_id])
    @comment = current_user.comment.find_by(item_id: @item.id, id: params[:id])
    @comment.destroy
    redirect_to item_path(params[:item_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
