class GroupMembersController < ApplicationController

  def create
    @group = Group.find(params[:id])
    user = User.find(params[:user_id])

    unless @group.users.include?(user)
      @group.group_members.create(user: user)
    end

    redirect_to group_path(@group)
  end
end
