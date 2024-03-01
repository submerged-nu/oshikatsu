class LikesController < ApplicationController
  before_action :require_login

  def create
    @post = Post.find(params[:post_id])
    @like = @post.likes.build(user: current_user)

    if @like.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post }
      end
    else
      # エラーハンドリング
    end
  end

  def destroy
    @like = current_user.likes.find_by(post_id: params[:post_id])
    @like.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @post }
    end
  end
end
