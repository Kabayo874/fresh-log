class Public::GroupsController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

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
    @group = Group.find(params[:id])
    @items = @group.items.order(created_at: :desc).page(params[:page])
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
