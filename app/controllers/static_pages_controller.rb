class StaticPagesController < ApplicationController
  layout false, only: %i[top_page]
  def privacy_policy; end

  def terms_of_service; end

  def how_to_use; end

  def top_page; end
end
