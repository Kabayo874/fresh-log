class Admin::GroupsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find_by(id: params[:id])
    if @group.nil?
      redirect_to admin_dashboards_path, alert: "このグループは存在しないか、すでに解散されています"
      return
    end

    @items = @group.items.order(created_at: :desc).page(params[:page])
  end

  def destroy
    @group = Group.find(params[:id])
    if @group.update(status: :admin_delete)
      redirect_to admin_dashboards_path, notice: 'グループを削除しました。'
    else
      redirect_to admin_group_path(@group), alert: 'グループの削除に失敗しました。'
    end
  end
end
