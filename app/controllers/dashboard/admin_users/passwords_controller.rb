module Dashboard
  module AdminUsers
    class PasswordsController < Devise::PasswordsController
      layout 'dashboard_not_authenticated'

      def update
        self.resource = resource_class.reset_password_by_token(resource_params)
        yield resource if block_given?
        if resource.errors.empty?
          resource.unlock_access! if unlockable?(resource)
          if Devise.sign_in_after_reset_password
            flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
            set_flash_message!(:notice, flash_message)
            resource.after_database_authentication
            sign_in(resource_name, resource)
          else
            flash[:notice] = t('.success')
          end
          respond_with resource, location: after_resetting_user_password_path_for(resource)
        else
          set_minimum_password_length
          @error = resource.errors.full_messages.join(', ')
          respond_with resource
        end
      end

      private

      def after_resetting_admin_user_password_path_for(_)
        new_dashboard_admin_user_session_path
      end
    end
  end
end
