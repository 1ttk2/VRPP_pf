class Public::UsersController < ApplicationController

  before_action :authenticate_user!
  ##マイページのアクション
  def show
    @user = User.find(params[:id])
    @posts = @user.posts
    #post_id = @user.posts.pluck(:id)
    #post_tags = PostTag.where(post_id: post_id)
    #tag_id = post_tags.pluck(:tag_id)
    #@tag_list = Tag.where(id: tag_id)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  def destroy
    @user = current_user
    @user.destroy
    redirect_to root_path
  end

  def unsubscribe
  end


  private

  def user_params
    params.require(:user).permit(:name, :Introduction, :profile_image, :is_deleted)
  end

end
