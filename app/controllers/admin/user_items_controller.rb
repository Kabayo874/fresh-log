class Admin::UserPostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @posts = @user.posts.order(created_at: :desc)
  end

end
