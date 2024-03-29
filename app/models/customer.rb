class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :post_pets ,dependent: :destroy
  has_many :favorites ,dependent: :destroy
  has_many :post_comments ,dependent: :destroy

  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :rooms, through: :entries
  has_one_attached :profile_image

  validates :name, uniqueness: true, presence: true,
    length: { minimum: 2, maximum: 30 }

  validates :email, presence: true

  validates :introduction,
    length: { maximum: 200 }

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |customer|
      customer.password = SecureRandom.urlsafe_base64
      # user.skip_confirmation!  # Confirmable を使用している場合は必要
      customer.name = "ゲスト"
    end
  end

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

  def self.looks(search, word)
    if search == "partial"
      @customer = Customer.where("name LIKE?","%#{word}%")
    else
      @customer = Customer.all
    end
  end
end