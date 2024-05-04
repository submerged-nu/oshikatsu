class User < ApplicationRecord
  before_validation :set_default_values

  authenticates_with_sorcery!
  mount_uploader :image, ImageUploader
  enum role: { user: 0, admin: 1 }
  has_many :posts
  has_many :comments
  has_many :likes, dependent: :destroy
  has_many :notifications
  validates :email, presence: true, uniqueness: true, on: :create,format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true, length: { minimum: 8 }, if: :password_required?
  validates :password, confirmation: true, if: :password_required?
  validate :name_length, on: :update

  private

  def set_default_values
    self.name = '推し大好き'
    self.image = File.open(Rails.root.join('public', 'images', 'default_icon.png'))
  end

  def password_required?
    new_record? || password.present?
  end

  def name_length
    return if name.blank?

    errors.add(:base, '名前は15文字以内にしてください') if name.length > 15
  end

  def name_present?
    errors.add(:base, '名前は1文字以上入力してください') unless name.present?
  end
end
