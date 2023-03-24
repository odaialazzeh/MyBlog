class Post < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  after_save :update_post_counter

  validates :title, presence: true, length: { maximum: 250 }
  validates :comments_counter, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :likes_counter, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def recent_comments
    comments.order(created_at: :desc).limit(5)
  end

  def update_post_counter
    author.increment!(:post_counter)
  end

  before_destroy :destroy_comments

  private

  def destroy_comments
    comments.destroy_all
  end
end
