class Public::GroupMembersController < ApplicationController
  before_action :set_group
  before_action :set_group_member, only: [:update]

  def index
    @group = Group.find(params[:group_id])
    @group_members = @group.group_members
      .joins(:user)
      .includes(:user)
      .where(users: { status: User.statuses[:active] })
  end

  def create
    @group = Group.find(params[:group_id])
    user = User.find_by(email: params[:email])
    if user && !@group.users.include?(user)
      @group.group_members.create(user: user)
      flash[:notice] = "メンバーを招待しました"
    else
      flash[:alert] = "ユーザーが存在しないか、すでにメンバーです"
    end
    redirect_to group_path(@group)
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
