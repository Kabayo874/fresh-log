class Public::UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    if @user.withdrawn?
      redirect_to root_path, alert: "このユーザーは退会しています"
    else
      items = @user.items
                   .left_joins(:group)
                   .includes(:group)
                   .where('groups.status IS NULL OR groups.status = ?', Group.statuses[:active])
      items = items.where(category: params[:category]) if params[:category].present?
      items = items.where(status: params[:status]) if params[:status].present?
  
      item_posts = @user.item_posts
                        .joins(:item)
                        .left_joins(item: :group)
                        .includes(item: [:group])
                        .where('groups.status IS NULL OR groups.status = ?', Group.statuses[:active])
      item_posts = item_posts.where(status: params[:status]) if params[:status].present?
      item_posts = item_posts.select do |post|
        params[:category].blank? || post.item.category == params[:category]
      end
  
      combined = items.to_a + item_posts.to_a
  
      case params[:sort]
      when "created_desc"
        combined.sort_by! { |card| card.created_at }.reverse!
      when "created_asc"
        combined.sort_by! { |card| card.created_at }
      when "star_desc"
        combined.sort_by! do |card|
          card.try(:star) || card.try(:item)&.try(:star) || 0
        end.reverse!
      else
        combined.sort_by! { |card| card.updated_at }.reverse!
      end
  
      @cards = Kaminari.paginate_array(combined).page(params[:page]).per(15)
    end
  end
  
  

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def groups
    @user = User.find(params[:id])
    @groups = @user.groups
  end

  def withdraw
    current_user.update(status: :withdrawn)
    current_user.item.destroy_all
    current_user.comments.destroy_all
    reset_session
    redirect_to root_path, notice: "退会処理が完了しました"
  end

  def favorites
    @user = User.find(params[:id])
    @favorite_items = @user.favorited_items.order(updated_at: :desc).page(params[:page]).per(15)
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile, :profile_image)
  end

  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to items_path
    end
  end

end
