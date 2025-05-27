class Admin::GroupsController < ApplicationController
  def show
    @group = Group.find(params[:id])
    @items = @group.items.order(created_at: :desc).page(params[:page])
  end
end
