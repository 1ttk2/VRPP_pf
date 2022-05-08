class Public::UsersController < ApplicationController

  before_action :authenticate_user!
  ##マイページのアクション
  def show
    @user = current_user
    @posts = @user.posts
    #post_id = @user.posts.pluck(:id)
    #post_tags = PostTag.where(post_id: post_id)
    #tag_id = post_tags.pluck(:tag_id)
    #@tag_list = Tag.where(id: tag_id)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    #binding.pry
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
