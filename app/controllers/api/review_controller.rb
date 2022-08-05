module Api
  class ReviewController < ApiController
    def search_review
      current_user = User.first

      all_reviews = current_user.followed_users.reviews

      all_reviews = all_reviews.get_filtered_reviews(search_params[:searched_key].downcase, current_user) if search_params[:search].present?

      render json: all_reviews, each_serializer: ReviewSerializer
    end

    private

    def search_params
      params.permit(:searched_key)
    end
  end
end
