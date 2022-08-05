class User < ApplicationRecord
  # has_secure_password

  has_many :books
  has_many :reviews
  has_many :followed_users, foreign_key: :follower_id, class_name: 'FollowRelationship'
  has_many :followees, through: :followed_users
  has_many :following_users, foreign_key: :followee_id, class_name: 'FollowRelationship'
  has_many :followers, through: :following_users

  validates :username, :email, presence: true

  def filtered_followed_user_ids(searching_key)
    # byebug
    self.followees.where(Arel.sql("users.username ILIKE '%#{searching_key}%'")).ids
  end
end
