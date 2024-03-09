class Post < ApplicationRecord
  belongs_to :customer,dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  
  validates :title,presence:true
  validates :introduction,presence:true,length:{maximum:1000}
end
