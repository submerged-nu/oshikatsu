class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :posts
  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true, length: { minimum: 8 }
  validates :password, confirmation: true
end
