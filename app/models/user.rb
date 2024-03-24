# frozen_string_literal: true

class User < ApplicationRecord
  authenticates_with_sorcery!
  mount_uploader :image, ImageUploader
  enum role: { user: 0, admin: 1 }
  has_many :posts
  has_many :comments
  has_many :likes, dependent: :destroy
  # ユーザー新規作成の際のバリデーション
  validates :email, presence: true, uniqueness: true, on: :create,format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true, length: { minimum: 8 }, if: :password_required?
  validates :password, confirmation: true, if: :password_required?
  # ユーザー編集の際のバリデーション
  validate :name_length, on: :update

  private

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
