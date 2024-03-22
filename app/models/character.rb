# frozen_string_literal: true

class Character < ApplicationRecord
  has_many :posts
  validates :name, presence: true
end
