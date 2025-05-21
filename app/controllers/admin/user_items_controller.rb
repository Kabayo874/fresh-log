class Admin::UserPostsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    @posts = @user.posts.order(created_at: :desc)
  end

end
