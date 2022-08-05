module Search
  class BlacklistedAuthTokensService
    attr_reader :errors

    def initialize(params)
      @search_query = params[:q]
      @order_query = params[:o]
      @direction_query = params[:d]
      @params = params
      @records = BlacklistedAuthToken.all
    end

    def execute
      paginate
      order

      @records
    end

    private

    def paginate
      @records = @records.page(@params[:page])
                         .extending(JsonPaginatable)
    end

    def order
      if @order_query.present? && @direction_query.present?
        @records = @records.order(@order_query => @direction_query)

        return
      end

      @records = @records.order(created_at: :desc)
    end
  end
end
