module Shoppe
  class UserMailer < ActionMailer::Base
    def new_password(user)
      @user = user
      mail from: Shoppe.settings.outbound_email_address, to: user.email_address, subject: 'Your new Shoppe password'
    end
  end
end
