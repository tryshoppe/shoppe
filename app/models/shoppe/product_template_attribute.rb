module Shoppe
  class ProductTemplateAttribute < ActiveRecord::Base
    self.table_name = 'shoppe_product_template_attributes'

    belongs_to :product_template
    validates :key, presence: true

    default_scope { order :position }
  end
end
