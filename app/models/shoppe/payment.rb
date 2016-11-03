module Shoppe
  class Payment < ApplicationRecord
    # Additional callbacks
    extend ActiveModel::Callbacks
    define_model_callbacks :refund

    # The associated order
    #
    # @return [Shoppe::Order]
    belongs_to :order, class_name: 'Shoppe::Order'

    # An associated payment (only applies to refunds)
    #
    # @return [Shoppe::Payment]
    belongs_to :parent, class_name: 'Shoppe::Payment', foreign_key: 'parent_payment_id'

    # Validations
    validates :amount, numericality: true
    validates :reference, presence: true
    validates :method, presence: true

    # Payments can have associated properties
    key_value_store :properties

    # Callbacks
    after_create :cache_amount_paid
    after_destroy :cache_amount_paid
    before_destroy { parent.update_attribute(:amount_refunded, parent.amount_refunded + amount) if parent }

    # Is this payment a refund?
    #
    # @return [Boolean]
    def refund?
      amount < BigDecimal(0)
    end

    # Has this payment had any refunds taken from it?
    #
    # @return [Boolean]
    def refunded?
      amount_refunded > BigDecimal(0)
    end

    # How much of the payment can be refunded
    #
    # @return [BigDecimal]
    def refundable_amount
      refundable? ? (amount - amount_refunded) : BigDecimal(0)
    end

    # Process a refund from this payment.
    #
    # @param amount [String] the amount which should be refunded
    # @return [Boolean]
    def refund!(amount)
      run_callbacks :refund do
        amount = BigDecimal(amount)
        if refundable_amount >= amount
          transaction do
            self.class.create(parent: self, order_id: order_id, amount: 0 - amount, method: method, reference: reference)
            update_attribute(:amount_refunded, amount_refunded + amount)
            true
          end
        else
          fail Shoppe::Errors::RefundFailed, message: I18n.t('.refund_failed', refundable_amount: refundable_amount)
        end
      end
    end

    # Return a transaction URL for viewing further information about this
    # payment.
    #
    # @return [String]
    def transaction_url
      nil
    end

    private

    def cache_amount_paid
      order.update_attribute(:amount_paid, order.payments.sum(:amount))
    end
  end
end
