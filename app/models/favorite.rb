class Favorite < ApplicationRecord
  belongs_to :customer
  belongs_to :post_pet
  has_one :notification, as: :notifiable, dependent: :destroy
  after_create do
    create_notification(customer_id: post_pet.customer_id)
  end
end
