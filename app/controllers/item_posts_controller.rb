class ItemPostsController < ApplicationController
  def new
    @item = Item.find(params[:item_id])
    @item_post = ItemPost.new
  end
  
  def create
    item = Item.find(params[:item_id])
    post = current_user.item_posts.new(item_post_params)
    post.item_id = item.id
    post.save
    redirect_to item_path(item)
  end

  def edit
    @item = Item.find(params[:item_id])
    @item_post = ItemPost.find(params[:id])
  end

  def update
    @item = Item.find(params[:item_id])
    @item_post = ItemPost.find(params[:id])
    @item_post.update(item_post_params)
    redirect_to item_path(params[:item_id])
  end

  def destroy
    @item = Item.find(params[:item_id])
    @item_post = current_user.item_posts.find_by(item_id: @item.id, id: params[:id])
    @item_post.destroy
    redirect_to item_path(params[:item_id])
  end

  private

  def item_post_params
    params.require(:item_post).permit(:review, :image, :status)
  end

end
