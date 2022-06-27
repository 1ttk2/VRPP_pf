class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  #has_many :favorite_users, through: :favorites, source: :user
  validates :post_image, presence: true
  validates :explanation, presence: true, length:{maximum:250}
  validates :world_url, presence: true

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  has_one_attached :post_image

  def get_post_image(width,height)
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      post_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    post_image.variant(resize_to_limit: [width,height]).processed
  end

  def save_tag(sent_tags)
  # タグが存在していれば、タグの名前を配列として全て取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tags = current_tags - sent_tags
    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tags = sent_tags - current_tags


    # 古いタグを消す
    old_tags.each do |old|
      self.tags.delete
      Tag.find_by(name: old)
    end

    # 新しいタグを保存
    new_tags.each do |new|
      new_post_tag = Tag.find_or_initialize_by(name: new)
      post_tag = PostTag.where(post_id: self.id, tag_id: new_post_tag.id) #既にタグで紐づけられているか確認
      unless post_tag.present? #紐づいていない時
        self.tags << new_post_tag
      end
   end
  end

  def self.sort(selection)
    case selection
    when 'new' #新しく作った順
      return all.order(created_at: :DESC)
    when 'old' #古い投稿順
      return all.order(created_at: :ASC)
    when 'likes' #いいねの多い順
     #ids = Favorite.group(:post_id).order(Arel.sql('count(post_id) desc')).pluck(:post_id)
      #return where(id: ids).order_as_specified(id: ids)
      #return Kaminari.paginate_array(all.sort { |a, b| b.favorites.count <=> a.favorites.count})
      return left_joins(:favorites).group(:id).order('count(favorites.post_id) desc')
    when 'dislikes' #いいねの少ない順
     #ids = Favorite.group(:post_id).order(Arel.sql('count(post_id) asc')).pluck(:post_id)
      #return where(id: ids).order_as_specified(id: ids)
      #return Kaminari.paginate_array(all.sort { |a, b| a.favorites.count <=> b.favorites.count})
      return left_joins(:favorites).group(:id).order('count(favorites.post_id) asc')
    end
  end
end
