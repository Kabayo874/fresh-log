class Admin::ItemsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    @items = Item.includes(:user, :group, :item_posts, :comments).all

    case params[:sort]
    when "post_count_desc"
      @items = @items.sort_by { |item| -item.item_posts.size }
    when "post_count_asc"
      @items = @items.sort_by { |item| item.item_posts.size }
    when "comment_count_desc"
      @items = @items.sort_by { |item| -item.comments.size }
    when "comment_count_asc"
      @items = @items.sort_by { |item| item.comments.size }
    when "created_at_asc"
      @items = @items.sort_by(&:created_at)
    when "created_at_desc"
      @items = @items.sort_by(&:created_at).reverse
    else
      @items = @items.sort_by(&:created_at).reverse
    end

    @items = Kaminari.paginate_array(@items).page(params[:page]).per(20)
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
