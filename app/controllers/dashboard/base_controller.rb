module Dashboard
  class BaseController < ApplicationController
    layout 'dashboard'
    before_action :authenticate_dashboard_admin_user!
  end
end
