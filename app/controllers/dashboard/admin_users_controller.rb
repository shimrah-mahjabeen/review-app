module Dashboard
  class AdminUsersController < BaseController
    before_action :set_admin_user, only: %w[show edit update destroy]
    helper_method :order_params

    def index
      service = Search::AdminUsersService.new(params)
      @admin_users = service.execute
    end

    def show; end

    def order_params(order, direction)
      params.merge(o: order, d: direction, page: params[:page]).permit(:o, :d, :page)
    end

    private

    def set_admin_user
      @admin_user = AdminUser.find_by(id: params[:id])
    end

    def admin_user_params
      params.require(:admin_user).permit(
        :created_at, :updated_at, :email, :name, :password, :email
      )
    end
  end
end
