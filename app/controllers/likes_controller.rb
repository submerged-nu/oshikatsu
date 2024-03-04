class LikesController < ApplicationController
  before_action :require_login

  def create
    @post = Post.find(params[:post_id])
    @like = @post.likes.build(user: current_user)

    if @like.save
      respond_to do |format|
        format.turbo_stream
      end
    else
      flash.now[:danger] = 'エラーが発生しました'
      render :new
    end
  end

  def destroy
    @like = current_user.likes.find_by(post_id: params[:id])
    @post = @like.post
    @like.destroy
    respond_to do |format|
      format.turbo_stream
    end
  end
end
