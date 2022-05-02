class Public::UsersController < ApplicationController

  before_action :authenticate_user!
  ##マイページのアクション
  def show
    @user = current_user
  end

  def edit
  end

  def unsubcribe
  end
end
