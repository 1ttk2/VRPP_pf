class Public::PostsController < ApplicationController

  before_action :authenticate_user!
  def index
    @posts = Post.all
    #タグ一覧
    @tag_list=Tag.all
  end

  def search_tag
    @tag_list=Tag.all #検索結果画面でもタグ一覧表示
    @tag=Tag.find(params[:tag_id]) #検索されたタグを受け取る
    #byebug
    @posts=@tag.posts.page(params[:page]).per(10) #検索されたタグに紐づく投稿を表示
  end

  def show
    @post = Post.find(params[:id])
    @post_tags = @post.tags
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:tag_name].split(',')
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
      redirect_to users_my_page_path, notice: "投稿が完了しました"
    else
      @posts = Post.all
      render :index
    end
  end

  private

  def post_params
    params.require(:post).permit(:explanation, :world_url, :avatar_url, :post_image )
  end

end