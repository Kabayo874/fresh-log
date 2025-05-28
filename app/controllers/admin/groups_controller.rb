class Admin::GroupsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  
  def index
    @groups = Group.all
  end
  
  def show
    @group = Group.find(params[:id])
    @items = @group.items.order(created_at: :desc).page(params[:page])
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to admin_dashboards_path, notice: 'グループを削除しました。'
  end
end
