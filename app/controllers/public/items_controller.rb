class Public::ItemsController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  def new
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @item = @group.items.build(user: current_user)
    else
      @item = Item.new
    end
  end

  def create
    if item_params[:group_id].present?
      @group = Group.find(item_params[:group_id])
      @item = @group.items.build(item_params.except(:group_id))
      @item.user = current_user
    else
      @item = current_user.items.build(item_params)
    end
  
    if @item.save
      if @item.group.present?
        redirect_to group_path(@item.group)
      else
        redirect_to user_path(current_user) 
      end
    else
      render :new
    end
  end

  def index
    user_group_ids = current_user.groups.pluck(:id)

    sort_key = case params[:sort]
      when "created_asc"
        :created_asc
      when "star_desc"
        :star_desc
      when "created_desc"
        :created_desc
      else
        :updated_desc
      end
    
    category = params[:category]
    status_params = Array(params[:status])
  
    @items = Item.left_joins(:group)
               .includes(:user, :group)
               .where('groups.status IS NULL OR groups.status = ?', Group.statuses[:active])
               .where(
                 "(items.private = ?)" + # 公開投稿
                 " OR (items.user_id = ?)" + # 自分の投稿
                 " OR (items.group_id IN (?))", # 所属グループの投稿
                 false, current_user.id, user_group_ids
               )
    @items = @items.where(category: category) if category.present?
    @items = @items.where(status: status_params) if status_params.present?
  
    @item_posts = ItemPost.joins(:item)
    .left_joins(item: :group)
    .includes(:user, item: [:user, :group])
    .where('groups.status IS NULL OR groups.status = ?', Group.statuses[:active])
    .where(
      "(items.private = ?)" +
      " OR (items.user_id = ?)" +
      " OR (items.group_id IN (?))",
      false, current_user.id, user_group_ids
    )
    @item_posts = @item_posts.where(status: status_params) if status_params.present?
    @item_posts = @item_posts.where(items: { category: category }) if category.present?
  
    combined = @items + @item_posts
  
    combined.sort_by! do |record|
      case sort_key
      when :created_desc
        -record.created_at.to_i
      when :created_asc
        record.created_at.to_i
      when :star_desc
        -(record.is_a?(Item) ? (record.star || 0) : (record.item&.star || 0))
      else
        -record.updated_at.to_i
      end
    end    
  
    @cards = Kaminari.paginate_array(combined).page(params[:page]).per(15)
  end
  
  

  def show
    @item = Item.find(params[:id])
    @item_post = ItemPost.new
    @comment = Comment.new
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to item_path(@item.id)
    else
      render :edit
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    redirect_to items_path
  end


  private

  def item_params
    params.require(:item).permit(:title, :body, :image, :category, :status, :group_id, :star, :deadline, :private)
  end

  def is_matching_login_user
    item = Item.find(params[:id])
    unless item.user == current_user
      redirect_to items_path
    end
  end

end
