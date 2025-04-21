class ItemsController < ApplicationController
  def new
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @item = @group.items.build(user: current_user)
    else
      @item = Item.new
    end
  end

  def create
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @item = @group.items.build(item_params.except(:group_id))
      @item.user = current_user
    else
      @item = current_user.items.build(item_params)
    end
  
    if @item.save
      redirect_to items_path
    else
      render :new
    end
  end

  def index
    @items = Item.page(params[:page])
  end

  def show
    @item = Item.find(params[:id])
    @item_post = ItemPost.new
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    redirect_to item_path(item.id)
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    redirect_to items_path
  end


  private

  def item_params
    params.require(:item).permit(:title, :body, :image, :category)
  end
end
