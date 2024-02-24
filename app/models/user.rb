class User < ApplicationRecord
  authenticates_with_sorcery!
  mount_uploader :image, ImageUploader
  has_many :posts
  has_many :comments
  #ユーザー新規作成の際のバリデーション
  validates :email, presence: true, uniqueness: true,  on: :create, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true, length: { minimum: 8 }, if: :password_required?
  validates :password, confirmation: true, if: :password_required?
  #ユーザー編集の際のバリデーション
  validates :name, presence: true, on: :update
  validates :image, presence: true, on: :update

  private

  def password_required?
    new_record? || password.present?
  end
end
