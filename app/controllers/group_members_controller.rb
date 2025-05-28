class GroupMembersController < ApplicationController

  def create
    @group = Group.find(params[:group_id])
    user = User.find_by(email: params[:email])

    unless @group.users.include?(user)
      @group.group_members.create(user: user)
    end

    redirect_to group_path(@group)
  end
end
