class PostPet < ApplicationRecord
  belongs_to :customer,dependent: :destroy
  has_many :favorites,dependent: :destroy
  has_many :comments,dependent: :destroy
  #Action_Text
  has_rich_text :content
  
  validates :title,presence:true
  has_one_attached :image
  
  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end
  
  def favorited_by?(customer)
    favorites.exists?(customer_id: customer.id)
  end
end
