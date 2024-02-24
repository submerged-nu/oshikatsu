class Post < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  belongs_to :character
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :comments
  validates :image, presence: true
  validates :name, presence: true
  validates :body, presence: true
end
