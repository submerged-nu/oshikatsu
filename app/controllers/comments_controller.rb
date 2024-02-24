class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_post

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      respond_to do |format|
        format.html { redirect_to @post }
        format.js   # create.js.erbを探す
      end
    else
      flash[:danger].now = 'コメント投稿に失敗しました'
      render :new
    end
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
end
