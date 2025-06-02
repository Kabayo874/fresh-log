class Public::ItemPostsController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]
  before_action :authorize_posting, only: [:new, :create, :edit, :update, :destroy]

  def authorize_posting
    item = Item.find(params[:item_id])
    unless item.user == current_user || (item.group.present? && current_user.member_of?(item.group))
      redirect_to root_path, alert: '投稿する権限がありません'
    end
  end

  def new
    @item = Item.find(params[:item_id])
    @item_post = ItemPost.new
  end
  
  def create
    @item = Item.find(params[:item_id])
    @item_post = current_user.item_posts.new(item_post_params)
    @item_post.item_id = @item.id
    if @item_post.save
      if @item.group.present?
        redirect_to item_path(@item)
      else
        redirect_to item_path(@item)
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
      redirect_to item_path(@item)
    else
      render :edit
    end
  end

  def destroy
    @item = Item.find(params[:item_id])
    @item_post = ItemPost.find(params[:id])
      if @item_post.user == current_user
        @item_post.destroy
        redirect_to item_path(params[:item_id]), notice: "投稿を削除しました"
      else
        redirect_to item_path(params[:item_id]), alert: "削除できるのは自分の投稿のみです"
      end
  end

  private

  def item_post_params
    params.require(:item_post).permit(:review, :image, :status)
  end

  def is_matching_login_user
    item_post = ItemPost.find(params[:id])
    unless item_post.user == current_user
      redirect_to items_path
    end
  end


end
