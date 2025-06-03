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

      item_posts = @user.item_posts
                        .joins(:item)
                        .left_joins(item: :group)
                        .includes(item: [:group])
                        .where('groups.status IS NULL OR groups.status = ?', Group.statuses[:active])

      combined = (items + item_posts).sort_by(&:updated_at).reverse
      @cards = Kaminari.paginate_array(combined).page(params[:page]).per(12)

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
