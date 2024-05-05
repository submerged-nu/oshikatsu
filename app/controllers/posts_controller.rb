class PostsController < ApplicationController
  before_action :require_login, only: %i[new create destroy]
  before_action :set_liked_post_ids, only: %i[index]
  before_action :limit_posts, only: %i[new]

  def new
    @post = Post.new
  end

  def create
    character = Character.find_or_create_by(name: post_params[:name])
    @post = current_user.posts.build(post_params.except(:tags).merge(character_id: character.id))
    if @post.save
      post_success_action
    else
      flash[:notice] = "新規投稿は '画像必須' '名前は1~15文字' '推しへの愛を語るところは1000文字以内' です"
      render json: { redirect_url: new_post_path }
    end
  end

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:likes).order(created_at: :desc).page(params[:page]).per(60)
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.order(created_at: :desc)
    @comment = Comment.new
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    redirect_to root_path
    flash[:notice] = '投稿を削除しました'
  end

  private

  def post_params
    params.require(:post).permit(:name, :image, :body, tags_attributes: [:id, :name, :_destroy])
  end

  def process_tags(tags_string)
    tags_string.split(',').each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name.strip)
      @post.tags << tag unless @post.tags.include?(tag)
    end
  end

  def post_success_action
    process_tags(post_params[:tags])
    flash[:notice] = '投稿しました'
    render json: { redirect_url: posts_path }
  end

  def set_liked_post_ids
    @liked_post_ids = current_user&.likes.select(:post_id).map(&:post_id).to_set if current_user
  end

  def limit_posts
    start_of_day = Time.zone.now.beginning_of_day
    end_of_day = Time.zone.now.end_of_day
    posts_count = current_user.posts.where(created_at: start_of_day..end_of_day).count
    return if posts_count <= 9

    flash[:notice] = '1日の投稿数は10回までです'
    redirect_to root_path
  end
end
