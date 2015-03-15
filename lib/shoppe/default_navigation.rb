require 'shoppe/navigation_manager'

# This file defines all the default navigation managers used in Shoppe. Of course,
# modules can make changes to these by removing them or adding their own. This
# file is loaded on application initialization so if you make changes, you'll need
# to restart the webserver.

#
# This is the default navigation manager for the admin interface. 
#
Shoppe::NavigationManager.build(:admin_primary) do
  add_item :customers
  add_item :orders
  add_item :products
  add_item :product_categories
  add_item :delivery_services
  add_item :tax_rates
  add_item :users
  add_item :countries
  add_item :settings
end
