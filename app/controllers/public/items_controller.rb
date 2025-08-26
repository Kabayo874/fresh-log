class Public::ItemsController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  def new
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @item = @group.items.build(user: current_user)
    else
      @item = Item.new
    end
  end

  def create
    if item_params[:group_id].present?
      @group = Group.find(item_params[:group_id])
      @item = @group.items.build(item_params.except(:group_id))
      @item.user = current_user
    else
      @item = current_user.items.build(item_params)
    end
  
    if @item.save
      if @item.group.present?
        redirect_to group_path(@item.group), notice: '投稿しました。'
      else
        redirect_to user_path(current_user) , notice: '投稿しました。'
      end
    else
      render :new
    end
  end

  def index
    sort_key = case params[:sort]
               when "created_asc"   then :created_asc
               when "star_desc"     then :star_desc
               when "created_desc"  then :created_desc
               else :updated_desc
               end
  
    category = params[:category]
    status_params = Array(params[:status])
    item_table = Item.arel_table
  
    visible_condition = item_table[:private].eq(false).or(item_table[:private].eq(nil))
  

    #Item + ItemPost
    @items = Item.left_joins(:group)
                  .includes(:user, :group)
                  .where('groups.status IS NULL OR groups.status = ?', Group.statuses[:active])
                  .where(visible_condition)
    @items = @items.where(category: category) if category.present?
    @items = @items.where(status: status_params) if status_params.present?

    @item_posts = ItemPost.joins(:item)
                          .left_joins(item: :group)
                          .includes(:user, item: [:user, :group])
                          .where('groups.status IS NULL OR groups.status = ?', Group.statuses[:active])
                          .where(visible_condition)
    @item_posts = @item_posts.where(status: status_params) if status_params.present?
    @item_posts = @item_posts.where(items: { category: category }) if category.present?

    combined = @items + @item_posts

    combined.sort_by! do |record|
      case sort_key
      when :created_desc
        -record.created_at.to_i
      when :created_asc
        record.created_at.to_i
      when :star_desc
        -(record.is_a?(Item) ? (record.star || 0) : (record.item&.star || 0))
      else
        -record.updated_at.to_i
      end
    end
  
    @cards = Kaminari.paginate_array(combined).page(params[:page]).per(15)
  end
  


  def show
    @item = Item.find(params[:id])

      # グループが存在して非アクティブなら見せない
    if @item.group.present? && @item.group.inactive?
      redirect_to items_path, alert: "この投稿は存在しません"
      return
    end

    # 非公開チェック
    if @item.private?
      if @item.group.present?
        # グループ投稿の非公開 → グループメンバー or 投稿者のみ閲覧可
        unless @item.group.users.include?(current_user) || @item.user == current_user
          redirect_to items_path, alert: "この投稿は非公開です"
          return
        end
      else
        # 個人投稿の非公開 → 投稿者のみ閲覧可
        unless @item.user == current_user
          redirect_to items_path, alert: "この投稿は非公開です"
          return
        end
      end
    end

    @item_post = ItemPost.new
    @comment = Comment.new
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to item_path(@item.id), notice: '変更を登録しました。'
    else
      flash.now[:alert] = '投稿に失敗しました。'
      render :edit
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    redirect_to items_path, notice: '投稿を削除しました。'
  end


  private

  def item_params
    params.require(:item).permit(:title, :body, :image, :category, :status, :group_id, :star, :deadline, :private)
  end

  def is_matching_login_user
    item = Item.find(params[:id])
    unless item.user == current_user
      redirect_to items_path
    end
  end

end
