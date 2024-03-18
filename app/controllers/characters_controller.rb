class CharactersController < ApplicationController
  def ranking
    start_of_previous_day = 1.day.ago.beginning_of_day
    end_of_previous_day = 1.day.ago.end_of_day

    @ranking = Character.select('characters.*, (COUNT(DISTINCT posts.id) + COUNT(DISTINCT likes.id) + COUNT(DISTINCT comments.id)) AS score')
                        .joins(:posts)
                        .left_joins(posts: [:likes, :comments])
                        .where('posts.created_at BETWEEN ? AND ? OR likes.created_at BETWEEN ? AND ? OR comments.created_at BETWEEN ? AND ?', start_of_previous_day, end_of_previous_day, start_of_previous_day, end_of_previous_day, start_of_previous_day, end_of_previous_day)
                        .group('characters.id')
                        .order('score DESC')
                        .limit(12)

    @most_liked_images = @ranking.each_with_object({}) do |character, hash|
      most_liked_post = character.posts
                                 .left_joins(:likes, :comments)
                                 .where('likes.created_at BETWEEN ? AND ? OR comments.created_at BETWEEN ? AND ?', start_of_previous_day, end_of_previous_day, start_of_previous_day, end_of_previous_day)
                                 .group('posts.id')
                                 .order(Arel.sql('COUNT(likes.id) + COUNT(comments.id) DESC'))
                                 .first

      if most_liked_post.nil?
        most_liked_post = character.posts.order('posts.created_at ASC').first
      end

      hash[character.id] = most_liked_post&.image&.url
    end
  end
end
