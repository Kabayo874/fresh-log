class Admin::ItemsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
    @item_post = ItemPost.new
    @comment = Comment.new
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to admin_dashboards_path, notice: '投稿を削除しました。'
  end

end
