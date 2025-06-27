class Public::CommentsController < ApplicationController

  def create
    item = Item.find(params[:item_id])
    comment = current_user.comments.new(comment_params)
    comment.item_id = item.id
    if comment.save
      redirect_to item_path(item), notice: 'コメントを投稿しました。'
    else
      flash[:alert] = 'コメントの投稿に失敗しました。'
      redirect_to item_path(item)
    end    
  end

  def destroy
    @item = Item.find(params[:item_id])
    @comment = current_user.comments.find_by(item_id: @item.id, id: params[:id])
    @comment.destroy
    redirect_to item_path(params[:item_id]), notice: 'コメントを削除しました。'
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
