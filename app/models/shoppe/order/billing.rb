module Shoppe
  class Order < ActiveRecord::Base

    # The country which this order should be billed to
    #
    # @return [Shoppe::Country]
    belongs_to :billing_country, :class_name => 'Shoppe::Country', :foreign_key => 'billing_country_id'

    # Payments which have been stored for the order
    has_many :payments, :dependent => :destroy, :class_name => 'Shoppe::Payment'

    # Validations
    with_options :if => Proc.new { |o| !o.building? } do |order|
      order.validates :first_name, :presence => true
      order.validates :last_name, :presence => true
      order.validates :billing_address1, :presence => true
      order.validates :billing_address3, :presence => true
      order.validates :billing_address4, :presence => true
      order.validates :billing_postcode, :presence => true
      order.validates :billing_country, :presence => true
    end

    # The name for billing purposes
    #
    # @return [String]
    def billing_name
      company.blank? ? full_name : "#{full_name} (#{company})"
    end

    # The total cost of the order
    #
    # @return [BigDecimal]
    def total_cost
      self.delivery_cost_price +
      order_items.inject(BigDecimal(0)) { |t, i| t + i.total_cost }
    end

    # Return the price for the order
    #
    # @return [BigDecimal]
    def profit
      total_before_tax - total_cost
    end

    # The total price of all items in the basket excluding delivery
    #
    # @return [BigDecimal]
    def items_sub_total
      order_items.inject(BigDecimal(0)) { |t, i| t + i.sub_total }.round(2)
    end

    # The total price of the order before tax
    #
    # @return [BigDecimal]
    def total_before_tax
      self.delivery_price + self.items_sub_total
    end

    # The total amount of tax due on this order
    #
    # @return [BigDecimal]
    def tax
      self.delivery_tax_amount +
      order_items.inject(BigDecimal(0)) { |t, i| t + i.tax_amount }.round(2)
    end

    # The total of the order including tax
    #
    # @return [BigDecimal]
    def total
      self.delivery_price +
      self.delivery_tax_amount +
      order_items.inject(BigDecimal(0)) { |t, i| t + i.total }.round(2)
    end

    # The total amount due on the order
    #
    # @return [BigDecimal]
    def balance
      @balance ||= total - amount_paid
    end

    # Is there a payment still outstanding on this order?
    #
    # @return [Boolean]
    def payment_outstanding?
      balance > BigDecimal(0)
    end

    # Has this order been paid in full?
    #
    # @return [Boolean]
    def paid_in_full?
      !payment_outstanding?
    end

    # Is the order invoiced?
    #
    # @return [Boolean]
    def invoiced?
      !invoice_number.blank?
    end

  end
end
