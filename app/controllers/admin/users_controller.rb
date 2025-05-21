class Admin::UsersController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

    def index
      @users = User.all
    end
    
    def destroy
        @user = User.find(params[:id])
        @user.update(status: false)
        redirect_to admin_dashboards_path, notice: 'ユーザーを退会処理しました。'
    end
end
