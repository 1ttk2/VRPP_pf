class Public::UsersController < ApplicationController

  before_action :authenticate_user!
  ##マイページのアクション
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to users_my_page_path
    else
      render :edit
    end
  end

  def unsubcribe
  end

  private

  def user_params
    params.require(:user).permit(:name, :Introduction, :profile_image)
  end

end
