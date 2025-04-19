class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @items = @user.items
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end

  def groups
    @user = User.find(params[:id])
    @groups = @user.groups
  end


  private

  def user_params
    params.require(:user).permit(:name, :profile, :profile_image)
  end

end
