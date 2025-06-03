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
    if item_params[:group_id] .present?
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
    @items = Item.includes(:user, :group).to_a
    @item_posts = ItemPost.includes(:user, item: [:user, :group])
    combined = (@items + @item_posts).sort_by(&:updated_at).reverse
    @cards = Kaminari.paginate_array(combined).page(params[:page]).per(12)
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
    params.require(:item).permit(:title, :body, :image, :category, :status, :group_id)
  end

  def is_matching_login_user
    item = Item.find(params[:id])
    unless item.user == current_user
      redirect_to items_path
    end
  end

end
