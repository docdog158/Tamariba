class Notification < ApplicationRecord
  include Rails.application.routes.url_helpers
  default_scope -> { order(created_at: :desc) }
  belongs_to :post_pet, optional: true
  belongs_to :post_comment, optional: true

  belongs_to :visitor, class_name: 'Customer', foreign_key: 'visitor_id', optional: true
  belongs_to :visited, class_name: 'Customer', foreign_key: 'visited_id', optional: true

  def message
    visitor = self.visitor
    visited = self.visited
    
    case self.action
    when "follow"
      "#{visitor.name}さんがあなたをフォローしました"
    when "favorite"
      "#{visitor.name}さんが#{self.post_pet.title}にいいねしました"
    when "post_comment"
      if self.post_pet.customer_id == visited.id
        "#{visitor.name}さんが#{self.post_pet.customer.name}さんの投稿にコメントしました"
      end
    else
      "新しい通知があります"
    end
  end
  
  def notification_path(notification)
    if self.action === "post_comment"
      post_pet_path(notification.post_pet.id)
    elsif self.action === "favorite"
      customer_path(notification.visitor.id)
    end
  end
  
end
