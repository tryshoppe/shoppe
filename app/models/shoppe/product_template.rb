module Shoppe
  class ProductTemplate < ActiveRecord::Base

    self.table_name = 'shoppe_product_templates'

    has_many :product_template_attributes
    accepts_nested_attributes_for :product_template_attributes,
                                  allow_destroy: true,
                                  reject_if: proc { |attributes| attributes['key'].blank? }

    validates :name, presence: true, uniqueness: true

  end
end
