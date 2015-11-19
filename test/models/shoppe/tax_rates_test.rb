require 'test_helper'

module Shoppe
  class TaxRatesTest < ActiveSupport::TestCase
    
    test "description" do
      rate = create(:standard_tax)
      assert_equal "Standard Tax (20.0)", rate.description
    end
    
    test "rate can be provided" do
      # create an environment with some countries so we can test that tax rates only apply to certain countries
      create_environment
      # create a rate which only applies to eu members
      rate = create(:standard_tax, :country_ids => Country.where(:eu_member => true).pluck(:id))
      # create an order which will (by default belong to the UK)
      order = create_order_with_products
      # check that tax is applied to this order
      assert_equal BigDecimal(20), rate.rate_for(order)
      # change the orders country to the US and the rate
      order.billing_country = Country.find_by_code2('US')
      # check it's rate is 0
      assert_equal BigDecimal(0), rate.rate_for(order)
      # change the rate so that it needs to use the delivery country
      assert rate.update_attributes(:address_type, 'delivery')
      # check that the rate is still zero because the order's delivery address
      # is the same as the biling address
      assert_equal BigDecimal(0), rate.rate_for(order)
      # set the delivery address to be the UK
      order.separate_delivery_address = true
      order.delivery_country = Country.find_by_code2('GB')
      # check the rate is now back to 20
      assert_equal BigDecimal(20), rate.rate_for(order)
    end
    
  end
end
