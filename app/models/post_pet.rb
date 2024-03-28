class PostPet < ApplicationRecord
  belongs_to :customer
  has_many :favorites,dependent: :destroy
  has_many :post_comments,dependent: :destroy
  has_many :post_tags,dependent: :destroy
  has_many :tags, through: :post_tags
  
  has_rich_text :content
  validates :content, presence: true

  validates :title,presence:true,
    length: { minimum: 2, maximum: 30 }

  has_one_attached :image
  validates :image,presence:true

  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end

  def favorited_by?(customer)
    customer.present? && favorites.exists?(customer_id: customer.id)
  end

  def self.looks(search, word)
    if search == "partial"
      @post_pet = PostPet.where("title LIKE ? OR content LIKE ?", "%#{word}%", "%#{word}%")
    else
      @post_pet = PostPet.all
    end
  end

  def save_tags(tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags

    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name:old_name)
    end

    new_tags.each do |new_name|
      tag = Tag.find_or_create_by(name:new_name)
      self.tags << tag
    end
  end

  def self.liked_posts(customer, page, per_page) # 1. モデル内での操作を開始
  includes(:favorites) # 2. post_favorites テーブルを結合
    .where(favorites: { customer_id: customer.id }) # 3. ユーザーがいいねしたレコードを絞り込み
    .order(created_at: :desc) # 4. 投稿を作成日時の降順でソート
    .page(page) # 5. ページネーションのため、指定ページに表示するデータを選択
    .per(per_page) # 6. ページごとのデータ数を指定
  end

end
