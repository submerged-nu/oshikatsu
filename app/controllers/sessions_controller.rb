class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:email])
    if @user&.valid_password?(params[:password])
      login_success_action
    else
      flash.now[:notice] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path
    flash[:success] = 'ログアウトしました'
  end

  private

  def login_success_action
    session[:user_id] = @user.id
    flash[:notice] = 'ログインしました'
    redirect_to root_path
  end
end
