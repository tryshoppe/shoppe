ENV["RAILS_ENV"] = "test"
require File.expand_path("../app/config/environment.rb",  __FILE__)
require "rails/test_help"

# Factory Girl
require 'factory_girl'
FactoryGirl.find_definitions
class ActiveSupport::TestCase

  include FactoryGirl::Syntax::Methods

  setup do
    ActionMailer::Base.deliveries.clear
  end

  private

  def create_order_with_products(options = {})
    order = create(:order)
    # create a product and a line
    product1 = create(:yealink_t22p, :initial_stock => options[:stock] || 10)
    item1 = order.order_items.create!(:quantity => options[:quantity] || 2, :ordered_item => product1)
    # create another product and a link
    product2 = create(:snom_870, :initial_stock => options[:stock] || 10)
    item2 = order.order_items.create!(:quantity => options[:quantity] || 1, :ordered_item => product2)

    if options[:confirmed]
      order.confirm!
    end

    # return the order
    order
  end

  def create_environment
    # add delivery services
    create(:first_class_post_with_prices)
    create(:delivery_service_with_prices)
    create(:saturday_delivery_with_prices)
    # add some countries
    create(:uk)
    create(:us)
    create(:france)
  end

end

class ControllerTestCase < ActionController::TestCase
  include Shoppe::Engine.routes.url_helpers
end
