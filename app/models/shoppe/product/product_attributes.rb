module Shoppe
  class Product < ActiveRecord::Base
  
    # Product attributes for this product
    has_many :product_attributes, -> { order(:position) }, :class_name => 'Shoppe::ProductAttribute'
  
    # Used for setting an array of product attributes which will be updated. Usually
    # received from a web browser.
    attr_accessor :product_attributes_array
    
    # After saving automatically try to update the product attributes based on the
    # the contents of the product_attributes_array array.
    after_save do
      if product_attributes_array.is_a?(Array)
        self.product_attributes.update_from_array(product_attributes_array)
      end
    end
  
  end
end
