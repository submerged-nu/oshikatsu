class Post < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  belongs_to :character
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  validates :image, presence: true, format: { with: /\A.*\.(png|jpg|jpeg)\z/i, message: 'jpg,png形式の画像を読み込ませてください' }
  validates :name, presence: true, length: { maximum: 20 }
  validates :body, presence: true, length: { maximum: 500 }

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
end
