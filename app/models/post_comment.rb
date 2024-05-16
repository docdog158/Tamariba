class PostComment < ApplicationRecord
  belongs_to :customer
  belongs_to :post_pet
  has_many :notifications, dependent: :destroy
end
