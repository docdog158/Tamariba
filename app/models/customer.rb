class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts ,dependent: :destroy
  has_many :favorites ,dependent: :destroy
  has_many :comments ,dependent: :destroy
  
  
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
  
  validates :name, uniqueness: true, presence: true,
    length: { minimum: 2, maximum: 20 }
  validates :email, presence: true
  
end
