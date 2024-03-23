class PostTag < ApplicationRecord
  belongs_to :post_pet
  belongs_to :tag
end