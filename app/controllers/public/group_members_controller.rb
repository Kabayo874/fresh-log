class Public::GroupMembersController < ApplicationController

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
end
