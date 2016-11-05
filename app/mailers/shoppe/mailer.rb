if defined?(ActionMailer)
  class Shoppe::Mailer < ActionMailer::Base
    def received(order)
      @order = order
      mail from: Shoppe.settings.outbound_email_address, to: order.email_address, subject: I18n.t('shoppe.order_mailer.received.subject', default: 'Order Confirmation')
    end

    def accepted(order)
      @order = order
      mail from: Shoppe.settings.outbound_email_address, to: order.email_address, subject: I18n.t('shoppe.order_mailer.received.accepted', default: 'Order Accepted')
    end

    def rejected(order)
      @order = order
      mail from: Shoppe.settings.outbound_email_address, to: order.email_address, subject: I18n.t('shoppe.order_mailer.received.rejected', default: 'Order Rejected')
    end

    def shipped(order)
      @order = order
      mail from: Shoppe.settings.outbound_email_address, to: order.email_address, subject: I18n.t('shoppe.order_mailer.received.shipped', default: 'Order Shipped')
    end

    def new_password(user)
      @user = user
      mail from: Shoppe.settings.outbound_email_address, to: user.email_address, subject: 'Your new Shoppe password'
    end
  end
end
