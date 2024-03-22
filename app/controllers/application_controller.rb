# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_current_user

  private

  def require_login
    return if logged_in?

    flash[:notice] = 'ログインが必要な機能です'
    redirect_to new_session_path
  end

  def set_current_user
    @current_user = User.find(session[:user_id]) if session[:user_id]
  end
end
