class Favorite < ApplicationRecord
    
  belongs_to :customer
  belongs_to :post_pet
  
  validates :customer_id, uniqueness: {scope: :post_pet_id}
  
end
