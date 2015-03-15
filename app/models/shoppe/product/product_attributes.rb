module Shoppe
  class Product < ActiveRecord::Base

    # Product attributes for this product
    has_many :product_attributes, -> { order(:position) }, :class_name => 'Shoppe::ProductAttribute'
    accepts_nested_attributes_for :product_attributes,
                                  allow_destroy: true,
                                  reject_if: proc { |attributes| attributes['key'].blank? }

  end
end
