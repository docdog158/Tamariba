class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :post_pets ,dependent: :destroy
  has_many :favorites ,dependent: :destroy
  has_many :comments ,dependent: :destroy
  has_one_attached :profile_image
  
  validates :name, uniqueness: true, presence: true,
    length: { minimum: 2, maximum: 30 }
    
  validates :email, presence: true
  
  validates :introduction,
    length: { maximum: 200 }
    
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [100, 100]).processed
  end  
  #自動ログイン
  
  # フォローしている,されている関連付け
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  
  # フォローしている、されている（フォロワー）ユーザーを取得
  has_many :followings, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  
  # 指定したユーザーをフォローする
  def follow(customer)
    active_relationships.create(followed_id: customer.id)
  end
  
  # 指定したユーザーのフォローを解除する
  def unfollow(customer)
    active_relationships.find_by(followed_id: customer.id).destroy
  end
  
  # 指定したユーザーをフォローしているかどうかを判定
  def following?(customer)
    followings.include?(customer)
  end
  
end
