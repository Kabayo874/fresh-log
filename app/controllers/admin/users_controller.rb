class Admin::UsersController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  
  def index
    sort = params[:sort] || 'created_at_desc'
    direction = sort.ends_with?('_desc') ? :desc : :asc
    order_column = sort.sub(/_(asc|desc)\z/, '')
  
    @users = User.all

    if params[:status_filter].present? && params[:status_filter] != 'all'
      @users = @users.where(status: params[:status_filter])
    end

    @users = @users.order(order_column => direction)
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
