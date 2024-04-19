class RecommendsController < ApplicationController
  before_action :require_login

  def index
    liked_posts = current_user.likes.order(created_at: :desc).limit(30).map(&:post)
    tag_counts = liked_posts.each_with_object(Hash.new(0)) do |post, counts|
      post.tags.each { |tag| counts[tag] += 1 }
    end
    top_tags = tag_counts.sort_by { |_tag, count| -count }.map(&:first).take(10)
    @recommends = Post.joins(:tags)
                  .where(tags: { id: top_tags })
                  .where.not(id: liked_posts.map(&:id))
                  .select("DISTINCT ON (posts.id) posts.*")
                  .order('RANDOM()')
                  .page(params[:page])
  end
end
