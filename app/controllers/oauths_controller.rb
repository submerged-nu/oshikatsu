class OauthsController < ApplicationController

#完全な新規登録ができること
#新規登録の際、アイコンとユーザー名が設定されること
#すでにメールアドレスが登録されていて、それに対してgoogleでログインができること
#うまくいかなかった場合、エラーを出すこと
#特有のメソッドを理解して、そこからメールアドレスだけを抜き出してユーザー登録をする

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
        @user.save
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
