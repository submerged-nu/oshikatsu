class Post < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  belongs_to :character
  validates :image, presence: true
  validates :name, presence: true
  validates :body, presence: true
end
