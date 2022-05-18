class Public::PostsController < ApplicationController
  before_action :correct_user, only: [:edit, :update]
  before_action :authenticate_user!, only: [:edit, :update, :new, :destroy]
  def index
    #@posts = Post.page(params[:page])
    @posts = Post.all
    #タグ一覧
    @tag_list = Tag.all
  end

  def search_tag
    @tag_list = Tag.all #検索結果画面でもタグ一覧表示
    @tag = Tag.find(params[:tag_id]) #検索されたタグを受け取る
    #byebug
    @posts = @tag.posts.page(params[:page]).per(10) #検索されたタグに紐づく投稿を表示
  end

  def search
    selection = params[:keyword]
    @posts = Post.sort(selection)
    #検索結果を表示させるためその場でrenderする_いいねが０の投稿が表示されないのでメンターに聞いてみる
    @tag_list = Tag.all
    render :index
  end

  def show
    @post_comment = PostComment.new
    @post = Post.find(params[:id])
    @post_tags = @post.tags
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
  end

  def update
    # postのid持ってくる
    @post = Post.find(params[:id])
    # 入力されたタグを受け取る
    tag_list = params[:post][:tag_name].split(',')
    # もしpostの情報が更新されたら
    if @post.update(post_params)
      # このpost_idに紐づいていたタグを@oldに入れる
      @old_relations = PostTag.where(post_id: @post.id)
      # それらを取り出し、消す。消し終わる
      @old_relations.each do |relation|
        relation.delete
      end
      @post.save_tag(tag_list)
      redirect_to post_path(@post.id), notice: '更新完了しました:)'
    else
      render :edit
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    # 受け取った値を,で区切って配列にする
    tag_list = params[:post][:tag_name].split(',')
    if @post.save
      @post.save_tag(tag_list)
      redirect_to user_path(current_user), notice: "投稿が完了しました"
    else
      render :new
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to user_path(current_user)
  end



  private

  def post_params
    params.require(:post).permit(:explanation, :world_url, :avatar_url, :post_image )
  end

  def correct_user
    @post = Post.find(params[:id])
    @user = @post.user
    redirect_to(posts_path) unless @user == current_user
  end

end
