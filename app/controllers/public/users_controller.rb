class Public::UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]
  before_action :reject_guest_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
  
    if @user.withdrawn?
      redirect_to root_path, alert: "このユーザーは退会しています"
      return
    end
  
    sort_key = params[:sort]
    category = params[:category]
    status_params = Array(params[:status])
  
    # アイテム取得
    items = @user.items
                 .left_joins(:group)
                 .includes(:group)
                 .where('groups.status IS NULL OR groups.status = ?', Group.statuses[:active])
  
    # 自分以外なら公開のみ
    items = items.where(private: [false, nil]) unless @user == current_user
  
    items = items.where(category: category) if category.present?
    items = items.where(status: status_params) if status_params.present?
  
    # アイテムポスト取得
    item_posts = @user.item_posts
                      .joins(:item)
                      .left_joins(item: :group)
                      .includes(item: [:group])
                      .where('groups.status IS NULL OR groups.status = ?', Group.statuses[:active])
  
    # 自分以外なら公開のみ
    item_posts = item_posts.where(items: { private: [false, nil] }) unless @user == current_user
    item_posts = item_posts.where(status: status_params) if status_params.present?
    item_posts = item_posts.select { |post| category.blank? || post.item.category == category }
  
    # 両方を統合
    combined = items.to_a + item_posts.to_a
  
    # 並び替え
    case sort_key
    when "deadline_asc"
      combined.sort_by! { |card| card.deadline || Time.zone.now }
    when "created_desc"
      combined.sort_by! { |card| card.created_at }.reverse!
    when "created_asc"
      combined.sort_by! { |card| card.created_at }
    when "star_desc"
      combined.sort_by! { |card| card.try(:star) || card.try(:item)&.try(:star) || 0 }.reverse!
    else
      combined.sort_by! { |card| card.updated_at }.reverse!
    end
  
    @cards = Kaminari.paginate_array(combined).page(params[:page]).per(15)
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

  def reject_guest_user
    if User::GUEST_USER_EMAIL == current_user.email
      redirect_to request.referer || root_path, alert: "ゲストユーザーはプロフィール編集を行えません。"
    end
  end

end
