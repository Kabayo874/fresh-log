class Public::GroupsController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
  
    if @group.save
      @group.group_members.create(user_id: current_user.id)
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def show
    @group = Group.active.find_by(id: params[:id])
    if @group.nil?
      redirect_to items_path, alert: "存在しないグループです"
      return
    end
  
    items = @group.items.includes(:user, :group)
    item_posts = ItemPost.includes(:user, item: [:user, :group])
                         .where(item_id: items.pluck(:id))
  
    if params[:category].present?
      items = items.where(category: params[:category])
      item_ids = items.pluck(:id)
      item_posts = item_posts.where(item_id: item_ids)
    end
  
    if params[:status].present?
      statuses = Array(params[:status])
      items = items.where(status: statuses)
      item_ids = items.pluck(:id)
      item_posts = item_posts.where(item_id: item_ids)
    end
  
    combined = (items.to_a + item_posts.to_a)
  
    case params[:sort]
    when "created_asc"
      combined.sort_by!(&:created_at)
    when "star_desc"
      combined.sort_by! do |item|
        item.respond_to?(:star) ? -item.star.to_i : 0
      end
    else
      combined.sort_by!(&:updated_at).reverse!
    end
  
    @cards = Kaminari.paginate_array(combined).page(params[:page]).per(15)
  end
  
  

  def edit
    @group = Group.find(params[:id])
  end

  def update
    group = Group.find(params[:id])
    if group.update(group_params)
      redirect_to group_path(group.id)
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    if @group.update(status: :owner_delete)
      redirect_to items_path, notice: "グループを解散しました"
    else
      render :edit, alert: "グループの解散に失敗しました"
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :description, :image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to items_path
    end
  end

end
