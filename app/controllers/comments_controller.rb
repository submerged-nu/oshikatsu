class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_post
  before_action :limit_comments, only: [:create]
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    flash[:notice] = if @comment.save
                       'コメントを投稿しました'
                     else
                       'コメントは200文字以内にしてください'
                     end
    redirect_to root_path
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy
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
end
