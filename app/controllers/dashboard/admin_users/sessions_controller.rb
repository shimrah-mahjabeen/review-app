module Dashboard
  module AdminUsers
    class SessionsController < Devise::SessionsController
      layout 'dashboard_not_authenticated'

      def after_sign_in_path_for(_)
        dashboard_admin_users_path
      end

      def after_sign_out_path_for(_)
        new_dashboard_admin_user_session_path
      end
    end
  end
end
