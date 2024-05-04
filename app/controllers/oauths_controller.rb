class OauthsController < ApplicationController

  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = params[:provider]
    if @user = login_from(provider)
      flash[:notice] = 'グーグルアカウントでログインしました'
      redirect_to root_path
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        flash[:notice] = 'グーグルアカウントで新規登録しました'
        redirect_to root_path
      rescue
        flash[:notice] = 'エラーが発生しました'
        redirect_to root_path
      end
    end
  end
end
