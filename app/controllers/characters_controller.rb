class CharactersController < ApplicationController
  def ranking
    set_time_range
    load_ranking
    load_most_liked_images
  end

  private

  def set_time_range
    @start_of_previous_day = 1.day.ago.beginning_of_day
    @end_of_previous_day = 1.day.ago.end_of_day
  end

  def load_ranking
    @ranking = Character.select('characters.*, (COUNT(DISTINCT posts.id) + COUNT(DISTINCT likes.id) + COUNT(DISTINCT comments.id)) AS score')
                        .joins(:posts)
                        .left_joins(posts: %i[likes comments])
                        .where(time_range_conditions, *time_range_values)
                        .group('characters.id')
                        .order('score DESC')
                        .limit(12)
  end

  def load_most_liked_images
    @most_liked_images = @ranking.each_with_object({}) do |character, hash|
      most_liked_post = most_liked_post_for(character)
      hash[character.id] = most_liked_post&.image&.url
    end
  end

  def most_liked_post_for(character)
    character.posts
             .left_joins(:likes, :comments)
             .where(time_range_conditions, *time_range_values)
             .group('posts.id')
             .order(Arel.sql('COUNT(likes.id) + COUNT(comments.id) DESC'))
             .first ||
    character.posts.order('posts.created_at ASC').first
  end

  def time_range_conditions
    'posts.created_at BETWEEN ? AND ? OR likes.created_at BETWEEN ? AND ? OR comments.created_at BETWEEN ? AND ?'
  end

  def time_range_values
    [@start_of_previous_day, @end_of_previous_day] * 3
  end
end
