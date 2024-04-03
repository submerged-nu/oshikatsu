class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:email])
    if @user&.valid_password?(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = 'ログインしました' 
      redirect_to new_session_path
    else
      flash[:notice] = 'ログインに失敗しました'
      redirect_to new_session_path
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to new_session_path
    flash[:success] = 'ログアウトしました'
  end
end
