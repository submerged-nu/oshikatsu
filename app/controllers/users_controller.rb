class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update]
  before_action :identity_verification, only: %i[edit update]

  def new
    @user = User.new
  end

  def create
    user_definition
    if @user.save
      auto_login(@user)
      flash[:notice] = '新規登録に成功しました'
      redirect_to root_path
    else
      flash.now[:danger] = '新規登録に失敗しました'
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(30)
    @liked_post_ids = current_user&.likes.pluck(:post_id).to_set
  end

  def edit; end

  def update

    if @user.update(user_update_params)
      flash[:notice] = 'ユーザー情報を更新しました。'
      render json: { redirect_url: posts_path }
    else
      flash[:notice] = '名前は15文字以内にしてください'
      render json: { redirect_url: edit_user_path(@user.id) }
    end
  end

  private

  def user_definition
    @user = User.new(user_create_params)
    @user.image = File.open(Rails.root.join('public', 'images', 'default_icon.png'))
    @user.name = '推し大好き'
  end

  def default_icon_url
    'https://oshikatsu-storage.s3.amazonaws.com/uploads/user/image/3/kkrn_icon_user_11.png'
  end

  def user_create_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def user_update_params
    params.require(:user).permit(:name, :image)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def identity_verification
    return if current_user == @user

    flash[:notice] = '他のユーザーの編集は行えません'
    redirect_to(root_path)
  end
end

