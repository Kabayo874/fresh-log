class Admin::UsersController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  
  def index
    @users = User.all
  end

  def destroy
    @user = User.find(params[:id])
    @user.update(status: :withdrawn)
    redirect_to admin_users_path, notice: 'ユーザーを退会処理しました。'
  end

  def show
    @user = User.find(params[:id])
    @items = @user.items.order(created_at: :desc).page(params[:page])
  end

  def groups
    @user = User.find(params[:id])
    @groups = @user.groups
  end
end
