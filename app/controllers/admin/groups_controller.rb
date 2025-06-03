class Admin::GroupsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    items = @group.items.includes(:user, :group).to_a
    item_posts = ItemPost.includes(:user, item: [:user, :group])
                         .where(item_id: items.map(&:id))
                         .to_a
    combined = (items + item_posts).sort_by(&:updated_at).reverse
    @cards = Kaminari.paginate_array(combined).page(params[:page]).per(12)
  end  

  def destroy
    @group = Group.find(params[:id])
    if @group.update(status: :admin_delete)
      redirect_to admin_groups_path, notice: 'グループを削除しました。'
    else
      redirect_to admin_group_path(@group), alert: 'グループの削除に失敗しました。'
    end
  end
end
