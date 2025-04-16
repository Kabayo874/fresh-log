class GroupsController < ApplicationController

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def show
    @item = Item.new
    @group = Group.find(params[:id])
  end

  def edit
  end

  def update
  end


  private

  def group_params
    params.require(:group).permit(:name, :discription, :image, :status)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to items_path
    end
  end

end
