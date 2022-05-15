class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  #has_many :favorite_posts, through: :favorites, source: :post

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  #ActiveStrageを使用
  has_one_attached :profile_image

  def get_profile_image(width,height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width,height]).processed
  end

  #is_deletedがfalseならtrueを返すようにしている
  def active_for_authentication?
    super && (is_deleted == false)
  end
end
