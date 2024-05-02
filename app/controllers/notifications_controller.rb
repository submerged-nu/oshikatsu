class NotificationsController < ApplicationController

  def index
    notifications = @current_user.notifications.where(read: false).map do |notification|
      message = case notification.event
      when 'like'
        "があなたの「#{notification.post.name}」にいいねしました！"
      when 'comment'
        "があなたの「#{notification.post.name}」にコメントしました！"
      end

      {
        user_name: notification.user.name,
        post_name: notification.post.name,
        message: notification.user.name + message
      }

    end
    render json: notifications
  end

  def mark_as_read
    return unless @current_user.notifications.where(read: false)

    @current_user.notifications.where(read: false).update_all(read: true)
    render json: { success: true }
  end
end
