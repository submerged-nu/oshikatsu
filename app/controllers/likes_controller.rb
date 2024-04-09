class LikesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :require_login
  before_action :set_liked_post_ids

  def create
    @post = Post.find(params[:post_id])
    @like = @post.likes.build(user: current_user)

    if @like.save
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
    respond_to(&:turbo_stream)
  end

  private

  def set_liked_post_ids
    @liked_post_ids = current_user.likes.select(:post_id).map(&:post_id).to_set if current_user
  end
end
