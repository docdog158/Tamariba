class Public::NotificationsController < ApplicationController
  before_action :authenticate_customer!

  def update
    notification = current_customer.passive_notifications.find(params[:id])
    notification.update(checked: true)
    redirect_to notification.notification_path(notification)
  end
  
  def index
    @notifications = current_customer.passive_notifications.page(params[:page]).per(20)
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end

end