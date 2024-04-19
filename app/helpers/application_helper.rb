module ApplicationHelper
  def twitter_image_url
    url = image_url('twitter_card.png')
    url = "https:#{url}" if url.start_with?("//s3")
    url
  end
end
