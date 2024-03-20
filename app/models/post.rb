class Post < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  belongs_to :character, optional: true
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  validate :image_present?
  validate :name_present?
  validate :name_length
  validates :body, length: { maximum: 1000 }

  private

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end

  def name_length
    if name.present? && name.length > 15
      errors.add(:base, "名前は最大15文字です")
    end
  end

  def name_present?
    unless name.present?
      errors.add(:base, "名前は必須です")
    end
  end

  def image_present?
    unless image.file.present?
      errors.add(:base, '画像は必須です')
    end
  end
end
