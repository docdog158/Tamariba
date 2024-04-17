class PostComment < ApplicationRecord
  belongs_to :customer
  belongs_to :post_pet
  has_many :notifications, dependent: :destroy

  def create_notification_comment!(current_customer, post_comment_id)
    temp_ids = PostComment.select(:customer_id).where(post_pet_id: id).where.not(id: current_customer.id).distinct
    temp_ids.each do |temp_id|
      save_notification_post_comment!(current_customer, post_comment_id, temp_id['customer_id'])
    end
    save_notification_comment!(current_customer, post_comment_id, customer_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_customer, post_comment_id, visited_id)
    notification = current_customer.active_notifications.new(
      post_pet_id: id,
      post_comment_id: post_comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end
