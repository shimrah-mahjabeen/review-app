class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :description, :rate, presence: true
  validates :title, presence: true, uniqueness: true

  def self.get_filtered_reviews(searching_key, user)
    Review.where(Arel.sql("lower(title) ILIKE '%#{searching_key}' OR
                           lower(description) ILIKE '%#{searching_key}%' OR
                           user_id ILIKE '%#{user.filtered_followed_user_ids(searching_key)}%'"))
  end
end
