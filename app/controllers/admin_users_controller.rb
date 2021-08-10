class AdminUsersController < ApplicationController
  before_action :set_admin_user, only: %w[edit update destroy]

  def index
    @admin_users = AdminUser.order(created_at: :desc).page(params[:page])
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
