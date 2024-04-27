class LikesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :require_login

  def create
    @post = Post.find(params[:post_id])
    @like = @post.likes.build(user: current_user)

    if @like.save
      send_notification 
      @liked_post_ids = current_user.likes.select(:post_id).map(&:post_id).to_set
      respond_to(&:turbo_stream)
    else
      flash.now[:danger] = 'エラーが発生しました'
      render :root_path
    end
  end

  def destroy
    @like = current_user.likes.find_by(post_id: params[:id])
    @post = @like.post
    @like.destroy
    @liked_post_ids = current_user.likes.select(:post_id).map(&:post_id).to_set
    respond_to(&:turbo_stream)
  end

  private

  def send_notification
    Notification.create(event: "like", user: current_user, post: @post)
    ActionCable.server.broadcast("notifications_#{@post.user.id}", { message: "#{current_user.name}があなたの投稿にいいねしました！" })
  end
end
