class PostsController < ApplicationController
  before_action :require_login, only: [:new, :create, :destroy]

  def new
    @post = Post.new
  end

  def create
    character = Character.find_or_create_by(name: post_params[:name])

    @post = current_user.posts.build(post_params.merge(character_id: character.id))
    if @post.valid?
      @post.save
      flash[:notice] = '投稿しました'
      redirect_to posts_path
    else
      flash.now[:danger] = '投稿に失敗しました'
      render :new
    end
  end

  def index
    @post = Post.all.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
    render partial: "posts/show", locals: { post: @post }
  end

  def destroy

  end

  private

  def post_params
    params.require(:post).permit(:name, :image, :body)
  end
end
