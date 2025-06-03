class Admin::GroupMembersController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  
  def index
    @group = Group.find(params[:group_id])
    @group_members = @group.group_members
      .joins(:user)
      .includes(:user)
      .where(users: { status: User.statuses[:active] })
  end

  def update
    if @group_member.update(group_member_params)
      flash[:notice] = "メンバーを更新しました"
    else
      flash[:alert] = "更新に失敗しました"
    end
    redirect_to group_group_members_path(@group)
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_group_member
    @group_member = @group.group_members.find(params[:id])
  end

  def group_member_params
    params.require(:group_member).permit(:role, :status)
  end


end
