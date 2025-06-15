class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @word = params[:word]

    if @word.present?
      like_word = "%#{@word}%"

      @users = User.where("name LIKE ? OR profile LIKE ?", like_word, like_word).page(params[:user_page]).per(6)


      items_by_title_or_body = Item.where("title LIKE ? OR body LIKE ?", like_word, like_word)
      item_posts_by_review = Item.joins(:item_posts).where("item_posts.review LIKE?", like_word)
      combined_items = (items_by_title_or_body + item_posts_by_review).uniq
      @items = Kaminari.paginate_array(combined_items).page(params[:page]).per(12)
    else
      @users = User.none.page(params[:user_page])
      @items = Kaminari.paginate_array([]).page(params[:page])
    end
  end

  def genre_search
    @genre_id = params[:genre_id]
    @genre = Genre.find(@genre_id)
    genre_items = Item.where(genre_id: @genre_id)
    genre_item_posts = ItemPost.joins(:item).where(items: { genre_id: @genre_id })
    combined_items = (genre_items + genre_item_posts).uniq
    @items = Kaminari.paginate_array(combined_items).page(params[:page]).per(12)
  end
end
