class ItemsController < ApplicationController
  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id
    @item.save
    redirect_to '/'
  end

  def index
  end

  def show
  end

  def edit
  end


  private

  def item_params
    params.require(:item).permit(:title, :body, :image, :category)
  end
end
