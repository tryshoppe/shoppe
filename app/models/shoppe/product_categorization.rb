module Shoppe
  class ProductCategorization < ActiveRecord::Base
  
    self.table_name = 'shoppe_product_categorizations'

    # Links back 
    belongs_to :product, class_name: 'Shoppe::Product'
    belongs_to :product_category, class_name: 'Shoppe::ProductCategory'
    
    # Validations
    validates_presence_of :product, :product_category

  end
end
