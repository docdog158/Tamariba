class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :post_pets, through: :post_tags

  validates :name, presence:true, length:{maximum:50}
  
  def self.looks(search, word)
    if search == "partial"
      @tag = Tag.where("name LIKE?","%#{word}%")
    else
      @tag = Tag.all
    end
  end

end