class Notification < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :customer
  belongs_to :notifiable, polymorphic: true
  def message
    if notifiable_type === "PostPet"
      "フォローしている#{notifiable.customer.name}さんが#{notifiable.title}を投稿しました"
    else
      "投稿した#{notifiable.post_pet.title}が#{notifiable.customer.name}さんにいいねされました"
    end
  end
  
  def notifiable_path(notification)
    if notification.notifiable_type === "PostPet"
      post_pet_path(notification.notifiable_id)
    else
      customer_path(notification.notifiable.customer.id)
    end
  end
end
