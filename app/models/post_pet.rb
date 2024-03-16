class PostPet < ApplicationRecord
  belongs_to :customer,dependent: :destroy
  has_many :favorites,dependent: :destroy
  has_many :post_comments,dependent: :destroy
  #Action_Text
  has_rich_text :content
  validates :content, presence: true
  
  validates :title,presence:true
  has_one_attached :image
  
  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["customer", "favorites", "image_attachment", "image_blob", "post_comments", "rich_text_content"]
  end
  
  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "customer_id", "id", "title", "updated_at"]
  end
  
  def favorited_by?(customer)
    favorites.exists?(customer_id: customer.id)
  end
  
  def self.liked_posts(customer, page, per_page) # 1. モデル内での操作を開始
  includes(:favorites) # 2. post_favorites テーブルを結合
    .where(favorites: { customer_id: customer.id }) # 3. ユーザーがいいねしたレコードを絞り込み
    .order(created_at: :desc) # 4. 投稿を作成日時の降順でソート
    .page(page) # 5. ページネーションのため、指定ページに表示するデータを選択
    .per(per_page) # 6. ページごとのデータ数を指定
  end
  
  
end
