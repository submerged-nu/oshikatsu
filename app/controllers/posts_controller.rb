class PostsController < ApplicationController
  before_action :require_login, only: [:new, :create, :destroy]

  def new
    @post = Post.new
  end

  def create
    character = Character.find_or_create_by(name: post_params[:name])
    @post = current_user.posts.build(post_params.except(:tags).merge(character_id: character.id))
    if @post.save
      process_tags(post_params[:tags])
      flash[:notice] = '投稿しました'
      render json: { redirect_url: posts_path }, status: :created
    else
     flash[:notice] = '画像は必須です'
     render :new
    end
  end

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).order(created_at: :desc).page(params[:page]).per(60)
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.order(created_at: :desc)
    @comment = Comment.new
  end

  def destroy

  end

  private

  def post_params
    params.require(:post).permit(:name, :image, :body, :tags)
  end

  def process_tags(tags_string)
    tags_string.split(',').each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name.strip)
      @post.tags << tag unless @post.tags.include?(tag)
    end
  end
end
