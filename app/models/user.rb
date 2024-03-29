class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :posts, inverse_of: :author, foreign_key: :author_id, dependent: :destroy
  has_many :comments, inverse_of: :author, foreign_key: :author_id
  has_many :likes, inverse_of: :author, foreign_key: :author_id

  validates :name, presence: true

  ROLES = %i[admin default].freeze

  def is?(requested_role)
    role == requested_role.to_s
  end

  def admin?
    is? :admin
  end

  def recent_posts(limit = 3)
    posts.order(created_at: :desc).limit(limit)
  end

  before_destroy :destroy_posts

  private

  def destroy_posts
    posts.destroy_all
  end

  after_create :send_confirmation_email

  private

  def send_confirmation_email
    self.send_confirmation_instructions
  end
end
