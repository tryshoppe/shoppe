module Shoppe
  class PasswordResetsController < Shoppe::ApplicationController

    layout 'shoppe/sub'
    skip_before_filter :login_required

    def create
      if user = Shoppe::User.find_by_email_address(params[:email_address])
        user.reset_password!
      end
      redirect_to login_path(:email_address => params[:email_address]), :notice => t('shoppe.sessions.reset_notice', email_address: params[:email_address])
    end

  end
end
