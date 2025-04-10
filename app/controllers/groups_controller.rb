class GroupsController < ApplicationController

  def new
    @group = Group.new
  end

  def show
    @item = Item.new
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      redirect_to groups_path
    else
      render '/items'
    end
  end


  private

  def group_params
    params.require(:group).permit(:name, :discription, :group_image, :status)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
  
end
