class Admin::ItemsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    @items = Item.includes(:user, :group, :item_posts, :comments).all

    case params[:group_filter]
    when "with_group"
      @items = @items.where.not(group_id: nil)
    when "without_group"
      @items = @items.where(group_id: nil)
    when "disbanded_group"
      @items = @items.joins(:group).where(groups: { status: [:owner_delete, :admin_delete] })
    end

    if params[:category_filter].present? && params[:category_filter] != "all"
      @items = @items.where(category: params[:category_filter])
    end

    if params[:status_filter].present? && params[:status_filter] != "all"
      @items = @items.where(status: params[:status_filter])
    end

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
    when "latest_posted_at_desc"
      @items = @items.sort_by { |item| item.item_posts.maximum(:created_at) || Time.at(0) }.reverse
    when "latest_posted_at_asc"
      @items = @items.sort_by { |item| item.item_posts.maximum(:created_at) || Time.at(0) }
    when "star"
      @items = @items.order(star: :asc)
    when "star_desc"
      @items = @items.order(star: :desc)
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
