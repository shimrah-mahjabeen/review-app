class ReviewSerializer < BaseSerializer
  attributes :title, :description, :rate, :book, :user

  def review_title
    object.title
  end

  def review_description
    object.description
  end

  def review_rating
    object.rate
  end

  def followed_user
    object.user
  end

  def book_title
    object.book.title
  end
end
