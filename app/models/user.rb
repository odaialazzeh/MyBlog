class User < ApplicationRecord
  has_many :posts, inverse_of: :author, foreign_key: :author_id
  has_many :comments, inverse_of: :author, foreign_key: :author_id
  has_many :likes, inverse_of: :author, foreign_key: :author_id

  validates :name, presence: true
  validates :post_counter, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def recent_posts(limit = 3)
    posts.order(created_at: :desc).limit(limit)
  end
end
