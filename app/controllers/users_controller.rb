class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :identity_verification, only: [:edit, :update]
  layout 'no_sidebar', only: [:new]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_create_params)
    if @user.save
      auto_login(@user)
      flash[:notice] = '新規登録に成功しました'
      redirect_to new_user_path
    else
      flash.now[:danger] = '新規登録に失敗しました'
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(30)
  end
  
  def edit; end

  def update
    if @user.update(user_update_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      flash[:error] = "ユーザー情報の更新に失敗しました。"
      render :edit
    end
  end

  private

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
    unless current_user == @user
      flash[:alert] = "他のユーザーの編集は行えません"
    redirect_to(root_path)
    end
  end
end
