class NotificationsController < ApplicationController

  def index
    notifications = @current_user.notifications.where(read: false).map do |notification|
      {
        user_name: notification.user.name,
        post_name: notification.post.name,
        type: notification.event
      }
    end
    render json: notifications
  end

  def mark_as_read
    @current_user.notifications.where(read: false).update_all(read: true)
    render json: { success: true }
  end
end
