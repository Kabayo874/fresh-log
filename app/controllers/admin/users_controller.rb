class Admin::UsersController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  
  def index
    @users = User.all
  end

  def destroy
    @user = User.find(params[:id])
    @user.update(status: :deactivated)
    redirect_to admin_users_path, notice: 'ユーザーを退会処理しました。'
  end

  def show
    @user = User.find(params[:id])
    items = @user.items.includes(:group).to_a
    item_posts = @user.item_posts.includes(item: [:group]).to_a
    combined = (items + item_posts).sort_by(&:updated_at).reverse
    @cards = Kaminari.paginate_array(combined).page(params[:page]).per(12)
  end

  def groups
    @user = User.find(params[:id])
    @groups = @user.groups
  end
end
