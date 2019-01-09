class Post < ApplicationRecord
  include Sluggable
  enum status: [:draft, :published]
  has_many :comments
  validates :title, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :body, presence: true
  
  def truncated_post
    body.slice(0, 25)
  end

  def self.posts_by_email(email)
    where(email: email)
  end
end