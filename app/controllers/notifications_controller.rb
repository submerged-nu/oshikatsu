class NotificationsController < ApplicationController
  def mark_as_read
    @current_user.notifications.where(read: false).update_all(read: true)
    render json: { success: true }
  end
end
