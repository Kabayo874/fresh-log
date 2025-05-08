class ItemPostsController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  def new
    @item = Item.find(params[:item_id])
    @item_post = ItemPost.new
  end
  
  def create
    @item = Item.find(params[:item_id])
    @item_post = current_user.item_posts.new(item_post_params)
    @item_post.item_id = @item.id
    if @item_post.save
      @item.update(status: @item.status)
      if @item.group.present?
        redirect_to group_path(@item.group)
      else
        redirect_to user_path(current_user)
      end
    else
      render :new
    end
  end

  def edit
    @item = Item.find(params[:item_id])
    @item_post = ItemPost.find(params[:id])
  end

  def update
    @item = Item.find(params[:item_id])
    @item_post = ItemPost.find(params[:id])
    if @item_post.update(item_post_params)
      @item.update(status: @item.status)
      redirect_to item_path(@item)
    else
      render :edit
    end
  end

  def destroy
    @item = Item.find(params[:item_id])
    @item_post = current_user.item_posts.find_by(item_id: @item.id, id: params[:id])
    @item_post.destroy
    redirect_to item_path(params[:item_id])
  end

  private

  def item_post_params
    params.require(:item_post).permit(:review, :image)
  end

  def is_matching_login_user
    item_post = ItemPost.find(params[:id])
    unless item_post.user == current_user
      redirect_to items_path
    end
  end


end
