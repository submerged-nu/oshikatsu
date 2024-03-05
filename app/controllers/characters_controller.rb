class CharactersController < ApplicationController
  def ranking
    @ranking = Character.select('characters.*, (COUNT(DISTINCT posts.id) + COUNT(DISTINCT likes.id) + COUNT(DISTINCT comments.id)) AS score')
                        .joins(:posts)
                        .left_joins(posts: [:likes, :comments])
                        .where('posts.created_at > ? OR likes.created_at > ? OR comments.created_at > ?', 24.hours.ago, 24.hours.ago, 24.hours.ago)
                        .group('characters.id')
                        .order('score DESC')

    @most_liked_images = @ranking.each_with_object({}) do |character, hash|
      most_liked_post = character.posts
                                 .where('posts.created_at > ?', 24.hours.ago)
                                 .left_joins(:likes)
                                 .group('posts.id')
                                 .order('COUNT(likes.id) DESC')
                                 .first
      hash[character.id] = most_liked_post.image if most_liked_post
    end
  end
end
