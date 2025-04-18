class GroupsController < ApplicationController

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
    @group = Group.find(params[:id])
    @items = @group.items
  end

  def edit
  end

  def update
  end


  private

  def group_params
    params.require(:group).permit(:name, :discription, :image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to items_path
    end
  end

end
