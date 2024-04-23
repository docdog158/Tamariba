class PostPet < ApplicationRecord
  belongs_to :customer
  has_many :favorites,dependent: :destroy
  has_many :favorited_customers, through: :favorites, source: :customer

  has_many :week_favorites, -> { where(created_at: 1.week.ago.beginning_of_day..Time.current.end_of_day) }
  has_many :post_comments,dependent: :destroy
  has_many :post_tags,dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :notifications, as: :notifiable, dependent: :destroy
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

  def self.liked_posts(customer, page, per_page)
  includes(:favorites)
    .where(favorites: { customer_id: customer.id })
    .order(created_at: :desc)
    .page(page)
    .per(per_page)
  end

  after_create do
    customer.followers.each do |follower|
      notifications.create(customer_id: follower.id)
    end
  end

  scope :latest, -> { order(created_at: :desc) }
  scope :old, -> { order(created_at: :asc) }
  scope :most_favorited, -> {
    left_joins(:favorites)
      .group('post_pets.id')
      .order('COUNT(favorites.id) DESC')
  }
  
  from = Time.current.at_end_of_day
  to_week = (from - 6.day).at_beginning_of_day
  to_month = (from - 1.month)
end
