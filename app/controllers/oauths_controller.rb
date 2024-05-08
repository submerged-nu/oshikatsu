class OauthsController < ApplicationController

  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = params[:provider]
    return redirect_to root_path, notice: 'グーグルアカウントでログインしました' if @user = login_from(provider)

    if @user = create_from(provider)
      @user.name = '推し大好き'
      @user.image = File.open(Rails.root.join('public', 'images', 'default_icon.png'))
      @user.save
      reset_session
      auto_login(@user)
      flash[:notice] = 'グーグルアカウントで新規登録しました'
      redirect_to root_path
    else
      flash[:notice] = 'エラーが発生しました'
      redirect_to root_path
    end
  end
end
