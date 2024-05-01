class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_post
  before_action :limit_comments, only: [:create]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      flash[:notice] = 'コメントを投稿しました'
      send_notification
    else
      flash[:notice] = 'コメントは200文字以内にしてください'
    end
    redirect_to root_path
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def limit_comments
    start_of_day = Time.zone.now.beginning_of_day
    end_of_day = Time.zone.now.end_of_day
    comments_count = current_user.comments.where(created_at: start_of_day..end_of_day).count
    return if comments_count <= 9

    flash[:notice] = '1日のコメント数は10回までです'
    redirect_to root_path
  end

  def send_notification
    Notification.create(event: "comment", user: @post.user, post: @post)
    ActionCable.server.broadcast("notifications_#{@post.user.id}", { message: "#{current_user.name}があなたの投稿にコメントしました！" })
  end
end
